import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'kamar_page.dart';
import 'login_page.dart';


// =========================================================
// 1. MAIN WIDGET (ProfilePage)
// =========================================================
class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// =========================================================
// 2. STATE MANAGEMENT & LOGIC
// =========================================================
class _ProfilePageState extends State<ProfilePage> {
  // -------------------------------------------------------
  // A. STATE VARIABLES (DATA ADMIN & REKENING)
  // -------------------------------------------------------
  String _adminName = 'Pengelola Griya Kemuning';
  String _adminEmail = 'adminkos@gmail.com';
  String _adminPhone = '+62 813-7070-9330';

  String _bankName = 'Bank BCA';
  String _noRekening = '123-456-7890';
  String _namaRekening = 'Griya Kemuning';

  // -------------------------------------------------------
  // B. FUNGSI DIALOG LOGOUT
  // -------------------------------------------------------
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A222D),
        title: const Text('Konfirmasi Log Out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari sesi Admin Griya Kemuning?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            child: const Text('Ya, Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // C. FUNGSI EDIT PROFIL DIALOG
  // -------------------------------------------------------
  void _showEditProfileDialog() {
    TextEditingController nameCtrl = TextEditingController(text: _adminName);
    TextEditingController emailCtrl = TextEditingController(text: _adminEmail);
    TextEditingController phoneCtrl = TextEditingController(text: _adminPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A222D),
        title: const Text('Edit Profil Pengelola', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nama Pengelola',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email Admin',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nomor WhatsApp',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _adminName = nameCtrl.text.trim();
                _adminEmail = emailCtrl.text.trim();
                _adminPhone = phoneCtrl.text.trim();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil pengelola berhasil diperbarui!')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 3. MAIN UI BUILDER
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12181F),

      // -----------------------------------------------------
      // APPBAR / HEADER NAVIGATION
      // -----------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A222D),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.home_work_rounded, color: Color(0xFFD4AF37)),
            SizedBox(width: 10),
            Text(
              'GRIYA KEMUNING',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),

      // -----------------------------------------------------
      // BODY CONTENT
      // -----------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION 1: CARD ABOUT ME / KARTU PROFIL ADMIN DENGAN LOGO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A222D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  // Logo Kos Griya Kemuning
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo_gk2.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const CircleAvatar(
                            backgroundColor: Color(0xFFD4AF37),
                            child: Icon(Icons.person, size: 40, color: Colors.black),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _adminName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text('$_adminEmail • $_adminPhone', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                        const SizedBox(height: 8),
                        const Text(
                          'Aplikasi Sistem Informasi Kos Griya Kemuning Luxury Co-Living.',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit Profil',
                    icon: const Icon(Icons.edit_note_rounded, color: Color(0xFFD4AF37), size: 28),
                    onPressed: _showEditProfileDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 2: SEKSI REKENING PEMBAYARAN
            const Text('Informasi Rekening Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A222D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance_rounded, color: Color(0xFFD4AF37), size: 30),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_bankName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('$_noRekening a.n $_namaRekening', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Salin Rekening',
                    icon: const Icon(Icons.copy_rounded, color: Color(0xFFD4AF37)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _noRekening.replaceAll('-', '')));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Nomor Rekening $_bankName berhasil disalin!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 3: RINGKASAN LAPORAN KEUANGAN
            const Text('Ringkasan Keuangan Bulan Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A222D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Pemasukan', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Rp 3.000.000', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A222D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pending Tagihan', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Rp 2.000.000', style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // SECTION 4: INFORMASI SISTEM (ABOUT APP)
            const Text('Informasi Sistem & Aplikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A222D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.app_shortcut_rounded, 'Versi Aplikasi', 'v1.0.0 (Beta Build)'),
                  const Divider(color: Colors.white10),
                  _buildInfoRow(Icons.code_rounded, 'Tech Stack', 'Flutter Web, Express Node.js, MySQL'),
                  const Divider(color: Colors.white10),
                  _buildInfoRow(Icons.developer_mode_rounded, 'Developer', 'Tim Pengembang Griya Kemuning'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // SECTION 5: TOMBOL LOG OUT UTAMA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'LOG OUT DARI SISTEM ADMIN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 4. HELPER WIDGETS
  // =========================================================
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFFD4AF37)),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}