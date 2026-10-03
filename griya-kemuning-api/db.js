const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createPool({
  host: process.env.DB_HOST || 'mysql-e0966d3-daffahanayu-4306.a.aivencloud.com',
  port: process.env.DB_PORT || 13410,
  user: process.env.DB_USER || 'avnadmin',
  password: process.env.DB_PASSWORD, // Akan dibaca dari .env / Render Environment
  database: process.env.DB_NAME || 'defaultdb',
  ssl: {
    rejectUnauthorized: false // Wajib diset false untuk koneksi SSL Aiven Cloud
  },
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Cek koneksi pool saat inisialisasi
db.getConnection((err, connection) => {
  if (err) {
    console.error('Koneksi MySQL Cloud Gagal:', err.message);
  } else {
    console.log('Terhubung ke MySQL Aiven Cloud: defaultdb');
    connection.release();
  }
});

module.exports = db;