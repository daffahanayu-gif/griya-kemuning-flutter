const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// 1. Endpoint Get Semua Kamar
app.get('/api/kamar', (req, res) => {
  const sql = 'SELECT * FROM kamar';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ success: true, data: results });
  });
});

// 2. Endpoint Get Rekap Kamar & Penghuni (JOIN)
app.get('/api/penghuni-kamar', (req, res) => {
  const sql = `
    SELECT 
      k.id AS id_kamar,
      k.nomor AS nomor_kamar,
      k.harga,
      k.status,
      k.deskripsi,
      COALESCE(p.nama, '-') AS nama_penghuni,
      COALESCE(p.no_hp, '-') AS no_hp
    FROM kamar k
    LEFT JOIN penghuni p ON k.id = p.id_kamar
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ success: true, data: results });
  });
});

// 3. Endpoint Login Admin
app.post('/api/admin/login', (req, res) => {
  const { email, password } = req.body;
  const sql = 'SELECT * FROM admin WHERE email = ? AND password = ?';
  db.query(sql, [email, password], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length > 0) {
      res.json({ success: true, message: 'Login Berhasil', admin: results[0] });
    } else {
      res.status(401).json({ success: false, message: 'Email atau password salah' });
    }
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server API Griya Kemuning berjalan di port ${PORT}`);
});