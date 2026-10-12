const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL_CUSTOM,
  ssl: {
    rejectUnauthorized: false
  }
});

module.exports = pool;