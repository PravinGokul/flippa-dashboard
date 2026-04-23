import { createAuthUser } from "../firebase/auth";
import { db } from "../config/db";

const USERS = [
    { id: "00000000-0000-0000-0000-000000000001", email: "admin@flippa.dev", role: "admin", country: "US" },
    { id: "00000000-0000-0000-0000-000000000101", email: "seller.de@flippa.dev", role: "business_seller", country: "DE" },
    { id: "00000000-0000-0000-0000-000000000102", email: "buyer.in@flippa.dev", role: "consumer", country: "IN" },
];

export async function seedUsers() {
    console.log("Seeding users...");
    for (const u of USERS) {
        // 1. Create in Firebase Auth
        const auth = await createAuthUser(u.email, "Password@123", u.id);

        // 2. Create in Postgres
        await db.query(
            `
      INSERT INTO users (id, email, role, country_code, is_verified)
      VALUES ($1,$2,$3,$4,true)
      ON CONFLICT (id) DO UPDATE SET 
        role = EXCLUDED.role,
        country_code = EXCLUDED.country_code
      `,
            [auth.uid, u.email, u.role, u.country]
        );
        console.log(`- Seeded: ${u.email}`);
    }
}
