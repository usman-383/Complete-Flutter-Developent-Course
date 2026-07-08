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
});

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

app.get('/admin', adminAuth, (req, res) => {
    res.type('html').send(`
        <!doctype html>
        <html>
        <head>
            <meta charset="utf-8" />
            <title>Admin — Orders</title>
            <style>body{font-family:Arial,Helvetica,sans-serif;padding:20px;background:#f6f6f6} table{width:100%;border-collapse:collapse} th,td{padding:8px;border:1px solid #ddd} th{background:#eee}</style>
        </head>
        <body>
            <h1>Orders</h1>
            <div id="orders"></div>
            <h2>Email Logs</h2>
            <div id="emails"></div>
            <script>
                async function load(){
                    const o = await fetch('/admin/orders');
                    const orders = await o.json();
                    let html = '<table><tr><th>id</th><th>createdAt</th><th>customer</th><th>items</th><th>total</th><th>coupon</th></tr>';
                    orders.forEach(r=>{
                        html += `< tr ><td>${r.id}</td><td>${r.createdAt}</td><td>${r.customer.name || r.customer.email || ''}</td><td>${(r.items||[]).map(i=>i.name+ ' x'+i.quantity).join('<br/>')}</td><td>${r.total}</td><td>${r.coupon||''}</td></tr > `;
                    });
                    html += '</table>';
                    document.getElementById('orders').innerHTML = html;

                    const e = await fetch('/admin/email_logs');
                    const emails = await e.json();
                    let eh = '<table><tr><th>id</th><th>order</th><th>sentAt</th><th>recipient</th><th>subject</th><th>success</th><th>info</th></tr>';
                    emails.forEach(l=>{
                        eh += `< tr ><td>${l.id}</td><td>${l.order_id}</td><td>${l.sentAt}</td><td>${l.recipient}</td><td>${l.subject}</td><td>${l.success}</td><td>${l.info}</td></tr > `;
                    });
                    eh += '</table>';
                    document.getElementById('emails').innerHTML = eh;
                }
                load();
            </script>
        </body>
        </html>
    `);
});
