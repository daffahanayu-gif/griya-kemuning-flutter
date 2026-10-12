const { Pool } = require('pg');

// Gunakan HANYA DATABASE_URL_CUSTOM agar tidak bentrok dengan variabel integrasi Vercel
const connectionString = process.env.DATABASE_URL_CUSTOM;

if (!connectionString) {
  console.error("DATABASE_URL_CUSTOM belum diatur di Vercel!");
}

const pool = new Pool({
  connectionString: connectionString,
  ssl: {
    rejectUnauthorized: false
  }
});

module.exports = pool;