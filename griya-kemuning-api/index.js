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
    const [results] = await db.query('SELECT * FROM kamar');
    res.json({ success: true, data: results });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Endpoint Get Semua Data Penghuni / Reservasi
app.get('/api/penghuni', async (req, res) => {
  try {
    const [results] = await db.query('SELECT * FROM penghuni ORDER BY id DESC');
    // Gantilah baris 25 di index.js menjadi seperti ini:
    res.json(results);
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
    const [results] = await db.query(sql);
    res.json({ success: true, data: results });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 3. Endpoint Login Admin
app.post('/api/admin/login', async (req, res) => {
  const { email, password } = req.body;
  const sql = 'SELECT * FROM admin WHERE email = ? AND password = ?';
  try {
    const [results] = await db.query(sql, [email, password]);
    if (results.length > 0) {
      res.json({ success: true, message: 'Login Berhasil', admin: results[0] });
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

    let [kamarResult] = await db.query('SELECT id FROM kamar WHERE nomor = ?', [cleanNomor]);
    
    if (!kamarResult || kamarResult.length === 0) {
      const angkaKamar = cleanNomor.replace(/[^0-9]/g, '');
      [kamarResult] = await db.query(
        'SELECT id FROM kamar WHERE nomor = ? OR nomor = ?', 
        [angkaKamar, `Kamar ${angkaKamar}`]
      );
    }

    if (!kamarResult || kamarResult.length === 0) {
      return res.status(400).json({ 
        success: false, 
        message: `Kamar '${cleanNomor}' tidak ditemukan` 
      });
    }

    const idKamar = kamarResult[0].id;

    await db.query(
      'INSERT INTO penghuni (id_kamar, nama, no_hp, email, tanggal_masuk, status_reservasi) VALUES (?, ?, ?, ?, ?, ?)',
      [idKamar, nama, no_hp, email, tanggal_masuk, 'Pending']
    );

    await db.query('UPDATE kamar SET status = ? WHERE id = ?', ['Pending', idKamar]);

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
app.put('/api/reservasi/setujui/:id', (req, res) => {
  const { id } = req.params;

  // Cari dulu id_kamar dari reservasi yang mau disetujui
  const getPenghuniQuery = 'SELECT id_kamar FROM penghuni WHERE id = ?';

  db.query(getPenghuniQuery, [id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Data tidak ditemukan' });

    const idKamar = results[0].id_kamar;

    // Update status reservasi jadi 'Disetujui' & status kamar jadi 'Terisi'
    const updatePenghuni = 'UPDATE penghuni SET status_reservasi = "Disetujui" WHERE id = ?';
    const updateKamar = 'UPDATE kamar SET status = "Terisi" WHERE id = ?';

    db.query(updatePenghuni, [id], (err) => {
      if (err) return res.status(500).json({ error: err.message });

      db.query(updateKamar, [idKamar], (err) => {
        if (err) return res.status(500).json({ error: err.message });

        res.json({ message: 'Reservasi berhasil disetujui dan kamar resmi terisi!' });
      });
    });
  });
});

// 2. ENDPOINT MEMBATALKAN RESERVASI (CANCEL)
app.put('/api/reservasi/batal/:id', (req, res) => {
  const { id } = req.params;

  const getPenghuniQuery = 'SELECT id_kamar FROM penghuni WHERE id = ?';

  db.query(getPenghuniQuery, [id], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Data tidak ditemukan' });

    const idKamar = results[0].id_kamar;

    // Update status reservasi jadi 'Batal' & kembalikan status kamar jadi 'Tersedia'
    const updatePenghuni = 'UPDATE penghuni SET status_reservasi = "Batal" WHERE id = ?';
    const updateKamar = 'UPDATE kamar SET status = "Tersedia" WHERE id = ?';

    db.query(updatePenghuni, [id], (err) => {
      if (err) return res.status(500).json({ error: err.message });

      db.query(updateKamar, [idKamar], (err) => {
        if (err) return res.status(500).json({ error: err.message });

        res.json({ message: 'Reservasi dibatalkan dan kamar kembali tersedia!' });
      });
    });
  });
});

// Jalankan Server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server API Griya Kemuning berjalan di port ${PORT}`);
});