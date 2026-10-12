const { Pool } = require('pg');

const pool = new Pool({
  // Menggunakan variabel otomatis hasil Integrasi Supabase Vercel
  host: process.env.POSTGRES_HOST || process.env.DB_HOST,
  user: process.env.POSTGRES_USER || process.env.DB_USER,
  password: process.env.POSTGRES_PASSWORD || process.env.DB_PASSWORD,
  database: process.env.POSTGRES_DATABASE || process.env.DB_NAME,
  port: process.env.POSTGRES_PORT || process.env.DB_PORT || 5432,
  ssl: {
    rejectUnauthorized: false
  }
});

module.exports = pool;