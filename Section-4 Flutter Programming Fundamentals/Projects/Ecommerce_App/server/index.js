const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

const DB_FILE = path.join(__dirname, 'orders.json');
if (!fs.existsSync(DB_FILE)) fs.writeFileSync(DB_FILE, '[]');

app.post('/orders', (req, res) => {
    const order = req.body;
    if (!order || !order.customer || !order.items) {
        return res.status(400).json({ error: 'Invalid order payload' });
    }

    const orders = JSON.parse(fs.readFileSync(DB_FILE));
    const id = Date.now().toString(36);
    const record = { id, createdAt: new Date().toISOString(), ...order };
    orders.push(record);
    fs.writeFileSync(DB_FILE, JSON.stringify(orders, null, 2));

    res.json({ id });
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
