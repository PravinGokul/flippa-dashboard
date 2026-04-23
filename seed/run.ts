import { db } from "./config/db";
import { seedUsers } from "./steps/01_users";
import { seedListings } from "./steps/03_listings";
import admin from "firebase-admin";

// Initialize Firebase Admin once
admin.initializeApp({
    // Ensure GOOGLE_APPLICATION_CREDENTIALS points to your service account json
    credential: admin.credential.applicationDefault(),
    projectId: 'flippa-18c94',
});

async function run() {
    console.log("🚀 Starting Advanced Seed Flow...");

    try {
        await seedUsers();
        await seedListings();

        console.log("✅ Seeding complete!");
    } catch (error) {
        console.error("❌ Seeding failed:", error);
    } finally {
        await db.end();
    }
}

run();
