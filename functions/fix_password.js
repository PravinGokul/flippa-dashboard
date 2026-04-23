const admin = require('firebase-admin');

process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';

admin.initializeApp({ projectId: 'flippa-18c94' });
const auth = admin.auth();

async function fixPasswords() {
  console.log('🔑 Fixing passwords for all test users...');
  for (let i = 1; i <= 100; i++) {
    const email = `user${i}@flippa.test`;
    try {
      const user = await auth.getUserByEmail(email);
      await auth.updateUser(user.uid, { password: 'password123' });
      if (i % 10 === 0) console.log(`... fixed ${i} users`);
    } catch (e) {
      console.log(`Skipped ${email}: ${e.message}`);
    }
  }
  console.log('✅ Passwords fixed! Login with user1@flippa.test / password123');
  process.exit(0);
}

fixPasswords();
