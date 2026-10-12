const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST_CUSTOM || 'aws-0-ap-northeast-1.pooler.supabase.com',
  user: process.env.DB_USER_CUSTOM || 'postgres.fvhwneblamhuwcvxjtqr',
  password: process.env.DB_PASSWORD_CUSTOM,
  database: 'postgres',
  port: 6543,
  ssl: {
    rejectUnauthorized: false
  }
});

module.exports = pool;