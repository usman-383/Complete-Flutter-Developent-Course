const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => res.send('Temporary admin server running. Visit /admin'));
app.get('/admin', (req, res) => {
    res.type('html').send(`
    <!doctype html>
    <html>
      <head><meta charset="utf-8"><title>Admin (temp)</title></head>
      <body style="font-family:Arial,Helvetica,sans-serif;padding:20px;">
        <h1>Admin (temporary)</h1>
        <p>This is a temporary read-only admin page served while the main server is being repaired.</p>
        <p>Endpoints on the real server (orders, email logs, retries) are not available in this temporary server.</p>
      </body>
    </html>
  `);
});

app.listen(port, () => console.log(`Temporary admin server listening on http://localhost:${port}`));
