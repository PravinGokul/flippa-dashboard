const admin = require('firebase-admin');
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';
admin.initializeApp({projectId: 'flippa-18c94'});
admin.auth().listUsers(10)
  .then((listUsersResult) => {
    console.log('--- AUTH EMULATOR DIAGNOSTIC ---');
    console.log('Total Users Found:', listUsersResult.users.length);
    listUsersResult.users.forEach((userRecord) => {
      console.log(`- Email: ${userRecord.email}, UID: ${userRecord.uid}`);
    });
    process.exit(0);
  })
  .catch((error) => {
    console.error('Error fetching users:', error);
    process.exit(1);
  });
