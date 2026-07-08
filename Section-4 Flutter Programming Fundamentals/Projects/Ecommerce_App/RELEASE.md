Release / Final run instructions

1) Prepare server env
- Copy `.env.example` to `.env` inside the `server/` folder and set:
  - `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SENDER_EMAIL`
  - `ADMIN_USER`, `ADMIN_PASS`, `ADMIN_EMAIL`
  - `ALERT_THRESHOLD` (optional), `ALERTS_ENABLED` (optional), `DIGEST_ENABLED` (optional)
  - `STRIPE_SECRET_KEY` (optional)

2) Install and start server
```bash
cd server
npm install
npm start
```

3) Run sample orders (quick test)
```bash
cd server
npm run test-orders
```

4) Configure Flutter client
- Open `lib/config.dart` and set `serverBaseUrl` to your machine (use IP for device testing) and `stripePublishableKey` if using Stripe.
- Run:
```bash
flutter pub get
flutter run
```

5) Verify in browser
- Admin UI: http://localhost:3000/admin
- Use `ADMIN_USER`/`ADMIN_PASS` to log in.
- Use Admin UI to monitor orders, retries, logs, and run actions (Retry Now / Retry All / Send Digest Now).

6) Notes
- For PaymentSheet to work on device, follow `flutter_stripe` native setup for Android and iOS.
- If SMTP is not configured, emails will enqueue in `server/orders.db` and you can use admin UI to retry.
