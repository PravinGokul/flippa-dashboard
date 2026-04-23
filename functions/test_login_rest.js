const http = require('http');

const data = JSON.stringify({
  email: 'user1@flippa.test',
  password: 'password123',
  returnSecureToken: true
});

const options = {
  hostname: '127.0.0.1',
  port: 9099,
  path: '/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=fake-key',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': data.length
  }
};

console.log('🧪 Testing login for user1@flippa.test / password123...');

const req = http.request(options, (res) => {
  let body = '';
  res.on('data', (d) => { body += d; });
  res.on('end', () => {
    if (res.statusCode === 200) {
      console.log('✅ Login SUCCESS!');
      console.log(body);
    } else {
      console.error('❌ Login FAILED!');
      console.error('Status:', res.statusCode);
      console.error('Body:', body);
    }
    process.exit(0);
  });
});

req.on('error', (error) => {
  console.error('❌ Request error:', error);
  process.exit(1);
});

req.write(data);
req.end();
