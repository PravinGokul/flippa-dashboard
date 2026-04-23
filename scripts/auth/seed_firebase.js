/**
 * Firebase Auth Seed Script for FLIPPA
 * Synchronizes with Postgres deterministic users.
 */

const admin = require('firebase-admin');

// 1. Initialize Firebase Admin
// Assumes GOOGLE_APPLICATION_CREDENTIALS points to service-account.json
// or you are logged in via Firebase CLI
admin.initializeApp({
    projectId: 'flippa-18c94',
});

const auth = admin.auth();

const users = [
    {
        uid: '00000000-0000-0000-0000-000000000001',
        email: 'admin1@flippa.io',
        password: 'Password123!',
        displayName: 'Head Admin',
    },
    {
        uid: '00000000-0000-0000-0000-000000000002',
        email: 'admin2@flippa.io',
        password: 'Password123!',
        displayName: 'Operations Lead',
    },
    {
        uid: '00000000-0000-0000-0000-000000000101',
        email: 'alice.seller@gmail.com',
        password: 'Password123!',
        displayName: 'Alice Individual',
    },
    {
        uid: '00000000-0000-0000-0000-000000000102',
        email: 'bob.seller@gmail.com',
        password: 'Password123!',
        displayName: 'Bob Individual',
    },
];

async function seedUsers() {
    console.log('--- Starting Firebase Auth Seeding ---');

    for (const user of users) {
        try {
            // Check if user exists
            await auth.getUser(user.uid);
            console.log(`User ${user.email} already exists. Updating...`);
            await auth.updateUser(user.uid, {
                displayName: user.displayName,
                password: user.password,
            });
        } catch (error) {
            if (error.code === 'auth/user-not-found') {
                console.log(`Creating user: ${user.email}`);
                await auth.createUser({
                    uid: user.uid,
                    email: user.email,
                    password: user.password,
                    displayName: user.displayName,
                    emailVerified: true,
                });
            } else {
                console.error(`Error on ${user.email}:`, error.message);
            }
        }
    }

    console.log('--- Seeding Complete ---');
}

seedUsers()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });
