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

            const mailOptions = {
                from: sender,
                to: order.customer.email,
                subject: `Order Confirmation — ${id}`,
                text: `Thank you for your order!\n\nOrder id: ${id}\n\nItems:\n${itemsSummary}\n\nTotal: $${order.total}\n\nWe will process and ship your order soon.`,
            };

            transporter.sendMail(mailOptions, (err, info) => {
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
