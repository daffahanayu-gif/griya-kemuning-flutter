const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// 1. Endpoint Get Semua Kamar
app.get('/api/kamar', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM kamar');
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Endpoint Get Semua Data Penghuni / Reservasi
app.get('/api/penghuni', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM penghuni ORDER BY id DESC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. Endpoint Get Rekap Kamar & Penghuni (JOIN)
app.get('/api/penghuni-kamar', async (req, res) => {
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
  try {
    const result = await db.query(sql);
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 3. Endpoint Login Admin
app.post('/api/admin/login', async (req, res) => {
  const { email, password } = req.body;
  const sql = 'SELECT * FROM admin WHERE email = $1 AND password = $2';
  try {
    const result = await db.query(sql, [email, password]);
    if (result.rows.length > 0) {
      res.json({ success: true, message: 'Login Berhasil', admin: result.rows[0] });
    } else {
      res.status(401).json({ success: false, message: 'Email atau password salah' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 4. Endpoint Tambah Penghuni (Reservasi Landing Page)
app.post('/api/penghuni', async (req, res) => {
  console.log("📥 Data reservasi masuk:", req.body);

  const nama = req.body.nama;
  const no_hp = req.body.no_hp || req.body.noHp;
  const email = req.body.email || req.body.alamat_email || '';
  let tanggal_masuk = req.body.tanggal_masuk || req.body.tanggalMasuk;
  const nomor_kamar = req.body.nomor_kamar || req.body.nomorKamar || '';

  try {
    if (tanggal_masuk) {
      const d = new Date(tanggal_masuk);
      if (!isNaN(d.getTime())) {
        tanggal_masuk = d.toISOString().split('T')[0];
      }
    }

    const cleanNomor = nomor_kamar.replace(/\s*\(.*\)$/, '').trim();

    let kamarResult = await db.query('SELECT id FROM kamar WHERE nomor = $1', [cleanNomor]);
    
    if (!kamarResult.rows || kamarResult.rows.length === 0) {
      const angkaKamar = cleanNomor.replace(/[^0-9]/g, '');
      kamarResult = await db.query(
        'SELECT id FROM kamar WHERE nomor = $1 OR nomor = $2', 
        [angkaKamar, `Kamar ${angkaKamar}`]
      );
    }

    if (!kamarResult.rows || kamarResult.rows.length === 0) {
      return res.status(400).json({ 
        success: false, 
        message: `Kamar '${cleanNomor}' tidak ditemukan` 
      });
    }

    const idKamar = kamarResult.rows[0].id;

    await db.query(
      'INSERT INTO penghuni (id_kamar, nama, no_hp, email, tanggal_masuk, status_reservasi) VALUES ($1, $2, $3, $4, $5, $6)',
      [idKamar, nama, no_hp, email, tanggal_masuk, 'Pending']
    );

    await db.query('UPDATE kamar SET status = $1 WHERE id = $2', ['Pending', idKamar]);

    console.log(`✅ Reservasi Pending Berhasil: ${nama} - Kamar ID: ${idKamar}`);
    return res.status(200).json({ 
      success: true, 
      message: 'Reservasi berhasil dikirim. Menunggu konfirmasi admin.' 
    });

  } catch (error) {
    console.error('❌ Error Server:', error);
    return res.status(500).json({ success: false, error: error.message });
  }
});

// 1. ENDPOINT MENYETUJUI RESERVASI (ACC)
app.put('/api/reservasi/setujui/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const getPenghuni = await db.query('SELECT id_kamar FROM penghuni WHERE id = $1', [id]);
    if (getPenghuni.rows.length === 0) {
      return res.status(404).json({ message: 'Data tidak ditemukan' });
    }

    const idKamar = getPenghuni.rows[0].id_kamar;

    await db.query("UPDATE penghuni SET status_reservasi = 'Disetujui' WHERE id = $1", [id]);
    await db.query("UPDATE kamar SET status = 'Terisi' WHERE id = $1", [idKamar]);

    res.json({ message: 'Reservasi berhasil disetujui dan kamar resmi terisi!' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. ENDPOINT MEMBATALKAN RESERVASI (CANCEL)
app.put('/api/reservasi/batal/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const getPenghuni = await db.query('SELECT id_kamar FROM penghuni WHERE id = $1', [id]);
    if (getPenghuni.rows.length === 0) {
      return res.status(404).json({ message: 'Data tidak ditemukan' });
    }

    const idKamar = getPenghuni.rows[0].id_kamar;

    await db.query("UPDATE penghuni SET status_reservasi = 'Batal' WHERE id = $1", [id]);
    await db.query("UPDATE kamar SET status = 'Tersedia' WHERE id = $1", [idKamar]);

    res.json({ message: 'Reservasi dibatalkan dan kamar kembali tersedia!' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Jalankan Server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server API Griya Kemuning berjalan di port ${PORT}`);
});