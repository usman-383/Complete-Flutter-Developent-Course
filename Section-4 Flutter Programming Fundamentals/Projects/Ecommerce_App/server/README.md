# Minimal E-commerce Server (template)

This is a minimal Express server used by the Flutter demo app.

Endpoints:

- POST /orders
  - Body: { customer, items, total, coupon }
  - Saves order to `orders.json` and returns `{ id }`.

- POST /create-payment-intent
  - Body: { amount, currency }
  - Uses Stripe to create a PaymentIntent. Requires `STRIPE_SECRET_KEY` in `.env`.

Run locally:

1. cd server
2. npm install
3. copy `.env.example` to `.env` and set `STRIPE_SECRET_KEY` if you want payment intent support
4. npm start

Security:
- Do NOT commit your Stripe secret key. Use environment variables in production.
