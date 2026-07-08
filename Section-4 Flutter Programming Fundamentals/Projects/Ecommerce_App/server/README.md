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

Email setup:

- To enable order confirmation emails, add SMTP settings to your `.env` (see `.env.example`):
  - `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, and `SENDER_EMAIL`.
- The server will attempt to send a plain-text confirmation email to the customer's email after the order is saved.

Admin UI

- The server includes a simple password-protected admin UI at `http://localhost:3000/admin`.
- Set `ADMIN_USER` and `ADMIN_PASS` in your `.env` (defaults are shown in `.env.example`).
- The admin page lists recent orders and email logs.
