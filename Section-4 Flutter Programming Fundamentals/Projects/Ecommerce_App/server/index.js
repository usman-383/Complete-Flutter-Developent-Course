const express = require('express');
const path = require('path');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();
const sqlite3 = require('sqlite3').verbose();
const nodemailer = require('nodemailer');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// DB
const DB_PATH = path.join(__dirname, 'orders.db');
const db = new sqlite3.Database(DB_PATH);

db.serialize(() => {
    db.run(`CREATE TABLE IF NOT EXISTS orders (
    id TEXT PRIMARY KEY,
    createdAt TEXT,
    customer TEXT,
    items TEXT,
    total INTEGER,
    coupon TEXT
  )`);

    db.run(`CREATE TABLE IF NOT EXISTS email_logs (
    id TEXT PRIMARY KEY,
    order_id TEXT,
    sentAt TEXT,
    recipient TEXT,
    subject TEXT,
    success INTEGER,
    info TEXT
  )`);

    db.run(`CREATE TABLE IF NOT EXISTS email_retries (
    id TEXT PRIMARY KEY,
    order_id TEXT,
    recipient TEXT,
    subject TEXT,
    text TEXT,
    html TEXT,
    attempts INTEGER DEFAULT 0,
    nextAttemptAt INTEGER,
    lastError TEXT,
    createdAt INTEGER,
    notified INTEGER DEFAULT 0
  )`);

    db.run(`CREATE TABLE IF NOT EXISTS settings (
    key TEXT PRIMARY KEY,
    value TEXT
  )`);
});

const SETTINGS = {};
function loadSettings() {
    db.all('SELECT key, value FROM settings', (err, rows) => {
        if (err) return;
        (rows || []).forEach(r => { SETTINGS[r.key] = r.value; });
    });
}
loadSettings();

function getSettingSync(key) {
    if (Object.prototype.hasOwnProperty.call(SETTINGS, key)) return SETTINGS[key];
    return process.env[key] || null;
}

function setSetting(key, value, cb) {
    SETTINGS[key] = String(value);
    const stmt = db.prepare('INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?)');
    stmt.run(key, String(value), (err) => { stmt.finalize(); if (cb) cb && cb(err); });
}

function createTransporter() {
    const smtpHost = process.env.SMTP_HOST || '';
    const smtpPort = process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : 0;
    const smtpUser = process.env.SMTP_USER || '';
    const smtpPass = process.env.SMTP_PASS || '';
    if (!smtpHost || !smtpPort || !smtpUser || !smtpPass) return null;
    return nodemailer.createTransport({ host: smtpHost, port: smtpPort, secure: smtpPort === 465, auth: { user: smtpUser, pass: smtpPass } });
}

function enqueueEmailRetry(orderId, recipient, subject, text, html) {
    const id = `${Date.now().toString(36)}-retry`;
    const now = Date.now();
    const next = now + 60 * 1000;
    const stmt = db.prepare('INSERT INTO email_retries (id, order_id, recipient, subject, text, html, attempts, nextAttemptAt, lastError, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
    stmt.run(id, orderId, recipient, subject, text, html, 0, next, '', now, (err) => { if (err) console.error('enqueue error', err); stmt.finalize(); });
}

function processEmailRetries() {
    const now = Date.now();
    db.all('SELECT * FROM email_retries WHERE nextAttemptAt <= ? ORDER BY nextAttemptAt ASC LIMIT 10', [now], (err, rows) => {
        if (err) return console.error('retry select err', err);
        if (!rows || rows.length === 0) return;
        const transporter = createTransporter();
        if (!transporter) return console.warn('SMTP not configured — skipping retries');

        rows.forEach(r => {
            const mailOptions = { from: process.env.SENDER_EMAIL || process.env.SMTP_USER || '', to: r.recipient, subject: r.subject, text: r.text, html: r.html };
            transporter.sendMail(mailOptions, (err, info) => {
                const logId = `${Date.now().toString(36)}-log`;
                if (!err) {
                    const insert = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                    insert.run(logId, r.order_id, new Date().toISOString(), r.recipient, r.subject, 1, (info && info.response) ? info.response : 'sent');
                    insert.finalize();
                    db.run('DELETE FROM email_retries WHERE id = ?', [r.id]);
                    console.log('Retry sent', r.id);
                } else {
                    const attempts = (r.attempts || 0) + 1;
                    const backoff = Math.min(24 * 60 * 60 * 1000, Math.pow(2, attempts) * 60 * 1000);
                    const nextAttempt = Date.now() + backoff;
                    const upd = db.prepare('UPDATE email_retries SET attempts = ?, nextAttemptAt = ?, lastError = ? WHERE id = ?');
                    upd.run(attempts, nextAttempt, (err && err.message) ? err.message : String(err), r.id);
                    upd.finalize();
                    const insertFail = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                    insertFail.run(logId, r.order_id, new Date().toISOString(), r.recipient, r.subject, 0, (err && err.message) ? err.message : String(err));
                    insertFail.finalize();
                }
            });
        });
    });
}

setInterval(processEmailRetries, 60 * 1000);

// Basic routes
app.post('/orders', (req, res) => {
    const order = req.body;
    if (!order || !order.customer || !order.items) return res.status(400).json({ error: 'Invalid order payload' });
    const id = Date.now().toString(36);
    const createdAt = new Date().toISOString();
    const stmt = db.prepare('INSERT INTO orders (id, createdAt, customer, items, total, coupon) VALUES (?, ?, ?, ?, ?, ?)');
    stmt.run(id, createdAt, JSON.stringify(order.customer), JSON.stringify(order.items), order.total || 0, order.coupon || '', (err) => {
        stmt.finalize();
        if (err) return res.status(500).json({ error: 'DB error' });

        // attempt to send confirmation email
        const smtpHost = process.env.SMTP_HOST || '';
        const smtpPort = process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : 0;
        const smtpUser = process.env.SMTP_USER || '';
        const smtpPass = process.env.SMTP_PASS || '';
        const sender = process.env.SENDER_EMAIL || smtpUser || '';
        if (smtpHost && smtpPort && smtpUser && smtpPass && order.customer && order.customer.email) {
            const transporter = nodemailer.createTransport({ host: smtpHost, port: smtpPort, secure: smtpPort === 465, auth: { user: smtpUser, pass: smtpPass } });
            const itemsSummary = (order.items || []).map(it => `${it.quantity} x ${it.name} (@${it.price})`).join('\n');
            const htmlItems = (order.items || []).map(it => `<li>${it.quantity} x ${it.name} (@$${it.price})</li>`).join('');
            const mailOptions = { from: sender, to: order.customer.email, subject: `Order Confirmation — ${id}`, text: `Thank you for your order!\n\nOrder id: ${id}\n\nItems:\n${itemsSummary}\n\nTotal: $${order.total}\n`, html: `<div><h2>Thank you for your order!</h2><p>Order id: <strong>${id}</strong></p><ul>${htmlItems}</ul><p><strong>Total: $${order.total}</strong></p></div>` };
            transporter.sendMail(mailOptions, (err, info) => {
                const logId = `${Date.now().toString(36)}-log`;
                const success = err ? 0 : 1;
                const infoText = err ? (err.message || String(err)) : (info && info.response ? info.response : 'sent');
                const insert = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                insert.run(logId, id, new Date().toISOString(), order.customer.email || '', mailOptions.subject, success, infoText);
                insert.finalize();
                if (err) {
                    enqueueEmailRetry(id, order.customer.email || '', mailOptions.subject, mailOptions.text, mailOptions.html);
                }
            });
        }
        res.json({ id });
    });
});

// Stripe intent template
app.post('/create-payment-intent', async (req, res) => {
    const { amount, currency = 'usd' } = req.body || {};
    const stripeSecret = process.env.STRIPE_SECRET_KEY;
    if (!stripeSecret) return res.status(500).json({ error: 'Stripe secret key not configured' });
    const Stripe = require('stripe');
    const stripe = new Stripe(stripeSecret);
    try {
        const paymentIntent = await stripe.paymentIntents.create({ amount: Math.max(50, Math.round((amount || 0) * 100)), currency });
        res.json({ clientSecret: paymentIntent.client_secret });
    } catch (err) {
        console.error('stripe err', err);
        res.status(500).json({ error: 'Failed to create payment intent' });
    }
});

// Basic admin auth
function adminAuth(req, res, next) {
    const auth = req.headers['authorization'];
    const adminUser = process.env.ADMIN_USER || '';
    const adminPass = process.env.ADMIN_PASS || '';
    if (!adminUser || !adminPass) return res.status(403).send('Admin not configured');
    if (!auth || !auth.startsWith('Basic ')) { res.setHeader('WWW-Authenticate', 'Basic realm="Admin"'); return res.status(401).send('Authentication required'); }
    const base64 = auth.split(' ')[1];
    const creds = Buffer.from(base64, 'base64').toString('ascii');
    const [user, pass] = creds.split(':');
    if (user === adminUser && pass === adminPass) return next();
    res.setHeader('WWW-Authenticate', 'Basic realm="Admin"');
    return res.status(401).send('Invalid credentials');
}

app.get('/admin/orders', adminAuth, (req, res) => {
    db.all('SELECT * FROM orders ORDER BY createdAt DESC LIMIT 200', (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        const parsed = rows.map(r => ({ id: r.id, createdAt: r.createdAt, customer: JSON.parse(r.customer || '{}'), items: JSON.parse(r.items || '[]'), total: r.total, coupon: r.coupon }));
        res.json(parsed);
    });
});

app.get('/admin/email_logs', adminAuth, (req, res) => { db.all('SELECT * FROM email_logs ORDER BY sentAt DESC LIMIT 200', (err, rows) => { if (err) return res.status(500).json({ error: 'DB error' }); res.json(rows); }); });
app.get('/admin/email_retries', adminAuth, (req, res) => { db.all('SELECT * FROM email_retries ORDER BY nextAttemptAt ASC LIMIT 200', (err, rows) => { if (err) return res.status(500).json({ error: 'DB error' }); res.json(rows); }); });

app.get('/admin/settings', adminAuth, (req, res) => {
    res.json({ ALERT_THRESHOLD: getSettingSync('ALERT_THRESHOLD') || process.env.ALERT_THRESHOLD || '3', ALERTS_ENABLED: getSettingSync('ALERTS_ENABLED') || process.env.ALERTS_ENABLED || '1' });
});

app.post('/admin/settings', adminAuth, (req, res) => {
    const body = req.body || {};
    const tasks = [];
    if (Object.prototype.hasOwnProperty.call(body, 'ALERT_THRESHOLD')) tasks.push(cb => setSetting('ALERT_THRESHOLD', String(body.ALERT_THRESHOLD), cb));
    if (Object.prototype.hasOwnProperty.call(body, 'ALERTS_ENABLED')) tasks.push(cb => setSetting('ALERTS_ENABLED', String(body.ALERTS_ENABLED), cb));
    if (tasks.length === 0) return res.json({ ok: true });
    let i = 0; function runNext(err) { if (err) return res.status(500).json({ error: 'Failed to save settings' }); if (i >= tasks.length) return res.json({ ok: true }); const t = tasks[i++]; t(runNext); }
    runNext();
});

app.post('/admin/retry/:id/retry', adminAuth, (req, res) => {
    const id = req.params.id;
    db.get('SELECT * FROM email_retries WHERE id = ?', [id], (err, row) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        if (!row) return res.status(404).json({ error: 'Retry not found' });
        const transporter = createTransporter(); if (!transporter) return res.status(500).json({ error: 'SMTP not configured' });
        const mailOptions = { from: process.env.SENDER_EMAIL || process.env.SMTP_USER || '', to: row.recipient, subject: row.subject, text: row.text, html: row.html };
        transporter.sendMail(mailOptions, (err, info) => {
            const logId = `${Date.now().toString(36)}-log`;
            if (!err) { const insert = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)'); insert.run(logId, row.order_id, new Date().toISOString(), row.recipient, row.subject, 1, (info && info.response) ? info.response : 'sent'); insert.finalize(); db.run('DELETE FROM email_retries WHERE id = ?', [id]); return res.json({ ok: true, sent: true }); }
            const attempts = (row.attempts || 0) + 1; const backoff = Math.min(24 * 60 * 60 * 1000, Math.pow(2, attempts) * 60 * 1000); const nextAttempt = Date.now() + backoff; const update = db.prepare('UPDATE email_retries SET attempts = ?, nextAttemptAt = ?, lastError = ? WHERE id = ?'); update.run(attempts, nextAttempt, (err && err.message) ? err.message : String(err), id); update.finalize(); const insertFail = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)'); insertFail.run(logId, row.order_id, new Date().toISOString(), row.recipient, row.subject, 0, (err && err.message) ? err.message : String(err)); insertFail.finalize(); return res.status(500).json({ ok: false, error: (err && err.message) ? err.message : String(err) });
        });
    });
});

app.post('/admin/retry/:id/delete', adminAuth, (req, res) => { const id = req.params.id; db.run('DELETE FROM email_retries WHERE id = ?', [id], function (err) { if (err) return res.status(500).json({ error: 'DB error' }); return res.json({ ok: true, deleted: this.changes }); }); });

app.post('/admin/retry/all', adminAuth, (req, res) => {
    db.all('SELECT * FROM email_retries ORDER BY nextAttemptAt ASC LIMIT 1000', (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        if (!rows || rows.length === 0) return res.json({ ok: true, processed: 0 });
        const transporter = createTransporter();
        if (!transporter) return res.status(500).json({ error: 'SMTP not configured' });

        let processed = 0;
        rows.forEach(r => {
            const mailOptions = { from: process.env.SENDER_EMAIL || process.env.SMTP_USER || '', to: r.recipient, subject: r.subject, text: r.text, html: r.html };
            transporter.sendMail(mailOptions, (err, info) => {
                const logId = `${Date.now().toString(36)}-log`;
                if (!err) {
                    const insert = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                    insert.run(logId, r.order_id, new Date().toISOString(), r.recipient, r.subject, 1, (info && info.response) ? info.response : 'sent');
                    insert.finalize();
                    db.run('DELETE FROM email_retries WHERE id = ?', [r.id]);
                    processed++;
                } else {
                    const attempts = (r.attempts || 0) + 1;
                    const backoff = Math.min(24 * 60 * 60 * 1000, Math.pow(2, attempts) * 60 * 1000);
                    const nextAttempt = Date.now() + backoff;
                    const update = db.prepare('UPDATE email_retries SET attempts = ?, nextAttemptAt = ?, lastError = ? WHERE id = ?');
                    update.run(attempts, nextAttempt, (err && err.message) ? err.message : String(err), r.id);
                    update.finalize();
                    const insertFail = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                    insertFail.run(logId, r.order_id, new Date().toISOString(), r.recipient, r.subject, 0, (err && err.message) ? err.message : String(err));
                    insertFail.finalize();
                }
            });
        });

        return res.json({ ok: true, processed: rows.length });
    });
});

// Minimal safe admin page
app.get('/admin', adminAuth, (req, res) => {
    const html = '<!doctype html><html><head><meta charset="utf-8"><title>Admin</title></head><body style="font-family:Arial,Helvetica,sans-serif;padding:20px;">' +
        '<h1>Admin</h1><p>Use the API endpoints to view orders, retries and logs.</p>' +
        '<ul><li><a href="/admin/orders">Orders (JSON)</a></li><li><a href="/admin/email_retries">Email retries (JSON)</a></li><li><a href="/admin/email_logs">Email logs (JSON)</a></li></ul>' +
        '</body></html>';
    res.type('html').send(html);
});

function escHtml(s) { return String(s || ''); }

// Digest endpoint (simple)
app.post('/admin/digest/send', adminAuth, (req, res) => {
    // For safety, reuse existing sendDigestNow-like behavior: gather retries over threshold and try to send admin email
    const adminEmail = process.env.ADMIN_EMAIL || '';
    const transporter = createTransporter();
    if (!adminEmail || !transporter) return res.status(500).json({ error: 'admin email or SMTP not configured' });
    const threshold = parseInt(getSettingSync('ALERT_THRESHOLD') || process.env.ALERT_THRESHOLD || '3', 10);
    db.all('SELECT * FROM email_retries WHERE attempts >= ? ORDER BY attempts DESC LIMIT 100', [threshold], (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        if (!rows || rows.length === 0) return res.json({ ok: true, sent: 0 });
        const lines = rows.map(r => `Order: ${r.order_id || ''} | To: ${r.recipient} | Attempts: ${r.attempts}`);
        const mailOptions = { from: process.env.SENDER_EMAIL || process.env.SMTP_USER || '', to: adminEmail, subject: `Digest: ${rows.length} persistent email failures`, text: `Digest:\n\n${lines.join('\n')}` };
        transporter.sendMail(mailOptions, (err, info) => {
            const logId = `${Date.now().toString(36)}-log`;
            const insert = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
            insert.run(logId, '', new Date().toISOString(), adminEmail, mailOptions.subject, err ? 0 : 1, err ? (err.message || String(err)) : ((info && info.response) ? info.response : 'sent'));
            insert.finalize();
            if (!err) setSetting('LAST_DIGEST_AT', String(Date.now()));
            return res.json({ ok: !err, sent: rows.length });
        });
    });
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server listening on http://localhost:${port}`));
