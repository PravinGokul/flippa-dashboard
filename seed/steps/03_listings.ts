import { db } from "../config/db";

export async function seedListings() {
    console.log("Seeding listings...");

    // Example 1: B2B Lease Scenario
    const laptopId = "L0000000-0000-0000-0000-000000000010";
    const sellerId = "00000000-0000-0000-0000-000000000101";
    const categoryId = "c0000000-0000-0000-0000-000000000011"; // Laptops from schema.sql

    await db.query(`
    INSERT INTO listings (
      id, owner_user_id, category_id, title, description, listing_type, country_code, status
    ) VALUES (
      $1, $2, $3, 'MacBook Pro 16" Fleet (10 Units)',
      'Enterprise grade laptop rental for teams.',
      'lease', 'DE', 'active'
    ) ON CONFLICT (id) DO NOTHING
  `, [laptopId, sellerId, categoryId]);

    await db.query(`
    INSERT INTO pricing_models (
      listing_id, currency, price_type, amount, deposit_amount
    ) VALUES (
      $1, 'EUR', 'per_month', 120.00, 500.00
    ) ON CONFLICT DO NOTHING
  `, [laptopId]);

    console.log("- Seeded: MacBook Pro Fleet");
}
