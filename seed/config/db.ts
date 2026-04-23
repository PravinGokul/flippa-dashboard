import { Pool } from 'pg';

// Configure your database connection here
// Typically loaded from env.dev.ts or environment variables
export const db = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    database: process.env.DB_NAME || 'flippa',
    password: process.env.DB_PASSWORD || 'postgres',
    port: parseInt(process.env.DB_PORT || '5432'),
});

export async function query(text: string, params?: any[]) {
    return db.query(text, params);
}
