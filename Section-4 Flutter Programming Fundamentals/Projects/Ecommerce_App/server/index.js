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

// SQLite DB in server/orders.db
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
        createdAt INTEGER
    )`);
});

// Helper: create nodemailer transporter from env
function createTransporter() {
    const smtpHost = process.env.SMTP_HOST || '';
    const smtpPort = process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : 0;
    const smtpUser = process.env.SMTP_USER || '';
    const smtpPass = process.env.SMTP_PASS || '';
    if (!smtpHost || !smtpPort || !smtpUser || !smtpPass) return null;
    return nodemailer.createTransport({
        host: smtpHost,
        port: smtpPort,
        secure: smtpPort === 465,
        auth: { user: smtpUser, pass: smtpPass },
    });
}

// Enqueue an email for retry (persistent)
function enqueueEmailRetry(orderId, recipient, subject, text, html) {
    const id = `${Date.now().toString(36)}-retry`;
    const now = Date.now();
    const next = now + 60 * 1000; // first retry after 1 minute
    const stmt = db.prepare(
        'INSERT INTO email_retries (id, order_id, recipient, subject, text, html, attempts, nextAttemptAt, lastError, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    );
    stmt.run(id, orderId, recipient, subject, text, html, 0, next, '', now, (err) => {
        if (err) console.error('Failed to enqueue email retry', err);
        stmt.finalize();
    });
}

// Background worker: process due retries
async function processEmailRetries() {
    const now = Date.now();
    db.all('SELECT * FROM email_retries WHERE nextAttemptAt <= ? ORDER BY nextAttemptAt ASC LIMIT 10', [now], (err, rows) => {
        if (err) return console.error('Retry worker DB error', err);
        if (!rows || rows.length === 0) return;
        const transporter = createTransporter();
        if (!transporter) return console.warn('SMTP not configured; cannot process email retries');

        rows.forEach((r) => {
            const mailOptions = {
                from: process.env.SENDER_EMAIL || process.env.SMTP_USER || '',
                to: r.recipient,
                subject: r.subject,
                text: r.text,
                html: r.html,
            };

            transporter.sendMail(mailOptions, (err, info) => {
                const sentAt = new Date().toISOString();
                const logId = `${Date.now().toString(36)}-log`;
                if (!err) {
                    // insert success log
                    const insert = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                    insert.run(logId, r.order_id, sentAt, r.recipient, r.subject, 1, (info && info.response) ? info.response : 'sent');
                    insert.finalize();
                    // remove retry
                    db.run('DELETE FROM email_retries WHERE id = ?', [r.id]);
                    console.log('Retry email sent for', r.id);
                } else {
                    const attempts = (r.attempts || 0) + 1;
                    const backoff = Math.min(24 * 60 * 60 * 1000, Math.pow(2, attempts) * 60 * 1000); // exponential, cap 24h
                    const nextAttempt = Date.now() + backoff;
                    const update = db.prepare('UPDATE email_retries SET attempts = ?, nextAttemptAt = ?, lastError = ? WHERE id = ?');
                    update.run(attempts, nextAttempt, (err && err.message) ? err.message : String(err), r.id);
                    update.finalize();

                    const logIdFail = `${Date.now().toString(36)}-log`;
                    const infoText = err && err.message ? err.message : String(err);
                    const insertFail = db.prepare('INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)');
                    insertFail.run(logIdFail, r.order_id, new Date().toISOString(), r.recipient, r.subject, 0, infoText);
                    insertFail.finalize();
                    console.warn('Retry failed for', r.id, 'scheduling next attempt', new Date(nextAttempt).toISOString());
                }
            });
        });
    });
}

// start retry worker every minute
setInterval(processEmailRetries, 60 * 1000);

app.post('/orders', (req, res) => {
    const order = req.body;
    if (!order || !order.customer || !order.items) {
        return res.status(400).json({ error: 'Invalid order payload' });
    }

    const id = Date.now().toString(36);
    const createdAt = new Date().toISOString();
    const stmt = db.prepare(
        'INSERT INTO orders (id, createdAt, customer, items, total, coupon) VALUES (?, ?, ?, ?, ?, ?)'
    );

    try {
        stmt.run(
            id,
            createdAt,
            JSON.stringify(order.customer),
            JSON.stringify(order.items),
            order.total || 0,
            order.coupon || ''
        );
        stmt.finalize();
        // Attempt to send confirmation email if SMTP configured
        const smtpHost = process.env.SMTP_HOST || '';
        const smtpPort = process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : 0;
        const smtpUser = process.env.SMTP_USER || '';
        const smtpPass = process.env.SMTP_PASS || '';
        const sender = process.env.SENDER_EMAIL || smtpUser || '';

        if (smtpHost && smtpPort && smtpUser && smtpPass && order.customer && order.customer.email) {
            const transporter = nodemailer.createTransport({
                host: smtpHost,
                port: smtpPort,
                secure: smtpPort === 465, // true for 465, false for other ports
                auth: {
                    user: smtpUser,
                    pass: smtpPass,
                },
            });

            const itemsSummary = (order.items || [])
                .map((it) => `${it.quantity} x ${it.name} (@${it.price})`)
                .join('\n');

            const htmlItems = (order.items || [])
                .map((it) => `<li>${it.quantity} x ${it.name} (@$${it.price})</li>`)
                .join('');

            const mailOptions = {
                from: sender,
                to: order.customer.email,
                subject: `Order Confirmation — ${id}`,
                text: `Thank you for your order!\n\nOrder id: ${id}\n\nItems:\n${itemsSummary}\n\nTotal: $${order.total}\n\nWe will process and ship your order soon.`,
                html: `
                    <div style="font-family: Arial, Helvetica, sans-serif; color: #222;">
                        <h2 style="color:#333;">Thank you for your order!</h2>
                        <p>Order id: <strong>${id}</strong></p>
                        <h4>Items</h4>
                        <ul style="line-height:1.6;">${htmlItems}</ul>
                        <p><strong>Total: $${order.total}</strong></p>
                        <hr />
                        <p style="font-size:0.9em; color:#666;">We will process and ship your order soon.</p>
                    </div>
                `,
            };

            transporter.sendMail(mailOptions, (err, info) => {
                const logId = `${Date.now().toString(36)}-log`;
                const sentAt = new Date().toISOString();
                const recipient = order.customer.email || '';
                const subject = mailOptions.subject;
                const success = err ? 0 : 1;
                const infoText = err ? (err.message || String(err)) : (info && info.response ? info.response : 'sent');

                // insert log into DB
                try {
                    const insert = db.prepare(
                        'INSERT INTO email_logs (id, order_id, sentAt, recipient, subject, success, info) VALUES (?, ?, ?, ?, ?, ?, ?)'
                    );
                    insert.run(logId, id, sentAt, recipient, subject, success, infoText);
                    insert.finalize();
                } catch (e) {
                    console.error('Failed to insert email log', e);
                }

                if (err) {
                    console.error('Failed to send confirmation email', err);
                    // enqueue persistent retry
                    try {
                        enqueueEmailRetry(id, recipient, subject, mailOptions.text, mailOptions.html);
                    } catch (e) {
                        console.error('Failed to enqueue retry', e);
                    }
                } else {
                    console.log('Confirmation email sent:', info.response);
                }
            });
        }

        res.json({ id });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to save order' });
    }
});

// Template endpoint to create a Stripe PaymentIntent
app.post('/create-payment-intent', async (req, res) => {
    const { amount, currency = 'usd' } = req.body;

    // IMPORTANT: Add your STRIPE_SECRET_KEY to .env and do not commit it.
    const stripeSecret = process.env.STRIPE_SECRET_KEY;
    if (!stripeSecret) {
        return res.status(500).json({ error: 'Stripe secret key not configured on server' });
    }

    const Stripe = require('stripe');
    const stripe = new Stripe(stripeSecret);

    try {
        const paymentIntent = await stripe.paymentIntents.create({
            amount: Math.max(50, Math.round(amount * 100)),
            currency,
        });

        res.json({ clientSecret: paymentIntent.client_secret });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to create payment intent' });
    }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server listening on http://localhost:${port}`));

// --- Admin UI and APIs (basic auth protected) ---
function adminAuth(req, res, next) {
    const auth = req.headers['authorization'];
    const adminUser = process.env.ADMIN_USER || '';
    const adminPass = process.env.ADMIN_PASS || '';

    if (!adminUser || !adminPass) {
        return res.status(403).send('Admin not configured');
    }

    if (!auth || !auth.startsWith('Basic ')) {
        res.setHeader('WWW-Authenticate', 'Basic realm="Admin"');
        return res.status(401).send('Authentication required');
    }

    const base64Credentials = auth.split(' ')[1];
    const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
    const [user, pass] = credentials.split(':');

    if (user === adminUser && pass === adminPass) return next();

    res.setHeader('WWW-Authenticate', 'Basic realm="Admin"');
    return res.status(401).send('Invalid credentials');
}

app.get('/admin/orders', adminAuth, (req, res) => {
    db.all('SELECT * FROM orders ORDER BY createdAt DESC LIMIT 200', (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        const parsed = rows.map((r) => ({
            id: r.id,
            createdAt: r.createdAt,
            customer: JSON.parse(r.customer || '{}'),
            items: JSON.parse(r.items || '[]'),
            total: r.total,
            coupon: r.coupon,
        }));
        res.json(parsed);
    });
});

app.get('/admin/email_logs', adminAuth, (req, res) => {
    db.all('SELECT * FROM email_logs ORDER BY sentAt DESC LIMIT 200', (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        res.json(rows);
    });
});

app.get('/admin/email_retries', adminAuth, (req, res) => {
    db.all('SELECT * FROM email_retries ORDER BY nextAttemptAt ASC LIMIT 200', (err, rows) => {
        if (err) return res.status(500).json({ error: 'DB error' });
        // convert timestamps
        const parsed = (rows || []).map(r => ({
            id: r.id,
            order_id: r.order_id,
            recipient: r.recipient,
            subject: r.subject,
            attempts: r.attempts,
            nextAttemptAt: r.nextAttemptAt,
            lastError: r.lastError,
            createdAt: r.createdAt,
        }));
        res.json(parsed);
    });
});

app.get('/admin', adminAuth, (req, res) => {
    res.type('html').send(`
        <!doctype html>
        <html>
        <head>
            <meta charset="utf-8" />
            <title>Admin — Orders</title>
            <style>
              body{font-family:Arial,Helvetica,sans-serif;padding:20px;background:#f6f6f6}
              table{width:100%;border-collapse:collapse;margin-bottom:20px}
              th,td{padding:8px;border:1px solid #ddd;text-align:left}
              th{background:#eee}
              h1,h2{margin-top:0}
            </style>
        </head>
        <body>
            <h1>Orders</h1>
            <div id="orders"></div>
            <h2>Pending Email Retries</h2>
            <div id="retries"></div>
            <h2>Email Logs</h2>
            <div id="emails"></div>
            <script>
                function esc(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
                async function load(){
                    const [oR, rR, eR] = await Promise.all([fetch('/admin/orders'), fetch('/admin/email_retries'), fetch('/admin/email_logs')]);
                    const orders = await oR.json();
                    const retries = await rR.json();
                    const emails = await eR.json();

                    let oh = '<table><tr><th>id</th><th>createdAt</th><th>customer</th><th>items</th><th>total</th><th>coupon</th></tr>';
                    orders.forEach(r=>{
                        const customer = r.customer && (r.customer.name || r.customer.email) ? esc(r.customer.name||r.customer.email) : '';
                        const items = (r.items||[]).map(i=>esc(i.name)+' x'+(i.quantity||0)).join('<br/>');
                        oh += `< tr ><td>${esc(r.id)}</td><td>${esc(r.createdAt)}</td><td>${customer}</td><td>${items}</td><td>${esc(r.total)}</td><td>${esc(r.coupon||'')}</td></tr > `;
                    });
                    oh += '</table>';
                    document.getElementById('orders').innerHTML = oh;

                    let rh = '<table><tr><th>id</th><th>order</th><th>recipient</th><th>attempts</th><th>nextAttemptAt</th><th>lastError</th></tr>';
                    retries.forEach(rr=>{
                        const nextAt = rr.nextAttemptAt ? new Date(rr.nextAttemptAt).toISOString() : '';
                        rh += `< tr ><td>${esc(rr.id)}</td><td>${esc(rr.order_id)}</td><td>${esc(rr.recipient)}</td><td>${esc(rr.attempts)}</td><td>${esc(nextAt)}</td><td>${esc(rr.lastError)}</td></tr > `;
                    });
                    rh += '</table>';
                    document.getElementById('retries').innerHTML = rh;

                    let eh = '<table><tr><th>id</th><th>order</th><th>sentAt</th><th>recipient</th><th>subject</th><th>success</th><th>info</th></tr>';
                    emails.forEach(l=>{
                        eh += `< tr ><td>${esc(l.id)}</td><td>${esc(l.order_id)}</td><td>${esc(l.sentAt)}</td><td>${esc(l.recipient)}</td><td>${esc(l.subject)}</td><td>${esc(l.success)}</td><td>${esc(l.info)}</td></tr > `;
                    });
                    eh += '</table>';
                    document.getElementById('emails').innerHTML = eh;
                }
                load();
                setInterval(load, 30*1000);
            </script>
        </body>
        </html>
    `);
});
