// Simple test script to POST sample orders to the server
// Usage: node test-send-orders.js [serverBaseUrl]

const http = require('http');

const serverBase = process.argv[2] || process.env.SERVER_BASE || 'http://localhost:3000';
const url = new URL('/orders', serverBase).toString();

const orders = [
    {
        customer: { name: 'Test User 1', email: 'test1@example.com' },
        items: [{ name: 'Blue Shoe', quantity: 1, price: 49.99 }],
        total: 49.99,
        coupon: ''
    },
    {
        customer: { name: 'Test User 2', email: 'test2@example.com' },
        items: [{ name: 'Red Shoe', quantity: 2, price: 39.99 }],
        total: 79.98,
        coupon: 'SAVE10'
    }
];

function postOrder(order) {
    return new Promise((resolve, reject) => {
        const u = new URL(url);
        const data = JSON.stringify(order);
        const opts = {
            hostname: u.hostname,
            port: u.port || 80,
            path: u.pathname,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(data)
            }
        };

        const req = http.request(opts, (res) => {
            let body = '';
            res.on('data', (chunk) => body += chunk);
            res.on('end', () => { resolve({ status: res.statusCode, body }); });
        });
        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

(async () => {
    for (const o of orders) {
        try {
            const r = await postOrder(o);
            console.log('Posted order:', r.status, r.body);
        } catch (e) {
            console.error('Failed posting order', e);
        }
    }
})();
