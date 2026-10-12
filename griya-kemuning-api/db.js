const { Pool } = require('pg');

// Menggunakan connectionString utuh dari Vercel/Supabase Integration
const connectionString = process.env.POSTGRES_URL || process.env.SUPABASE_DATABASE_URL || process.env.DATABASE_URL;

const pool = connectionString
  ? new Pool({
      connectionString,
      ssl: { rejectUnauthorized: false }
    })
  : new Pool({
      host: process.env.POSTGRES_HOST || process.env.DB_HOST,
      user: process.env.POSTGRES_USER || process.env.DB_USER,
      password: process.env.POSTGRES_PASSWORD || process.env.DB_PASSWORD,
      database: process.env.POSTGRES_DATABASE || process.env.DB_NAME,
      port: process.env.POSTGRES_PORT || process.env.DB_PORT || 5432,
      ssl: { rejectUnauthorized: false }
    });

module.exports = pool;