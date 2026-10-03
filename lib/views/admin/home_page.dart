import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../../providers/dummy/room_data.dart';
import 'kamar_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'roomdetail_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '/widgets/room_card.dart';
import '../../service/api_service.dart';

// 1. WIDGET UTAMA (Membungkus Bottom Navigation Bar)
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String tag = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Daftar Halaman yang diakses via Bottom Navbar
  final List<Widget> _pages = [
    const HomeDashboardContent(), // Halaman Dashboard Utama
    const KamarPage(),            // Halaman Manajemen Kamar
    const ProfilePage(),          // Halaman Profil Admin
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1A222D),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.king_bed),
            label: 'Kamar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// 2. KONTEN DASHBOARD UTAMA (Dengan Foto Kamar & Fitur Lengkap)
class HomeDashboardContent extends StatefulWidget {
  const HomeDashboardContent({super.key});

  @override
  State<HomeDashboardContent> createState() => _HomeDashboardContentState();
}

class _HomeDashboardContentState extends State<HomeDashboardContent> {
  List<RoomModel> rooms = listKamarDummy;
  String _selectedFilter = 'Semua';

  // --- FUNGSI WA DIMASUKKAN DI SINI (DI DALAM CLASS) ---
  void _kirimWhatsApp(String? noHp, String nama, String roomName) async {
    String phoneToUse = noHp ?? '';
    
    if (phoneToUse.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor HP penghuni belum diisi!')),
      );
      return;
    }

    String formattedPhone = phoneToUse.replaceAll(RegExp(r'[^0-9]'), '');
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '62${formattedPhone.substring(1)}';
    }

    final String message = Uri.encodeComponent(
      'Halo $nama, mengingatkan untuk tagihan sewa $roomName. Terima kasih!',
    );
    
    final Uri waUrl = Uri.parse('https://wa.me/$formattedPhone?text=$message');

    if (await canLaunchUrl(waUrl)) {
      await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
        );
      }
    }
  }

  int get totalKamar => rooms.length;
  int get kamarTerisi => rooms.where((r) => !r.isAvailable).length;
  int get kamarKosong => rooms.where((r) => r.isAvailable).length;

  List<RoomModel> get filteredRooms {
    if (_selectedFilter == 'Terisi') {
      return rooms.where((r) => !r.isAvailable).toList();
    } else if (_selectedFilter == 'Kosong') {
      return rooms.where((r) => r.isAvailable).toList();
    }
    return rooms;
  }

  void _showWADialog(String nama, String kamar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A222D),
        title: const Text('Kirim Pesan WhatsApp', style: TextStyle(color: Colors.white)),
        content: Text('Kirim pengingat tagihan ke $nama ($kamar)?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Membuka WhatsApp untuk $nama...')),
              );
            },
            child: const Text('Kirim WA'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFF0F141C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A222D),
        elevation: 0,
        title: const Text('Dashboard Kos', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= 1. STATISTIK CARD =================
            Row(
              children: [
                _buildStatCard('Total Kamar', '$totalKamar', Colors.blue),
                const SizedBox(width: 10),
                _buildStatCard('Kamar Terisi', '$kamarTerisi', Colors.orange),
                const SizedBox(width: 10),
                _buildStatCard('Kamar Kosong', '$kamarKosong', Colors.green),
              ],
            ),
            const SizedBox(height: 25),

            // ================= 2. GRID STATUS KAMAR DENGAN FOTO =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Status Kamar',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedFilter,
                  dropdownColor: const Color(0xFF1A222D),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  items: ['Semua', 'Terisi', 'Kosong']
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedFilter = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<dynamic>>(
              future: ApiService.fetchKamar(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat kamar: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data kamar',
                        style: TextStyle(color: Colors.white)),
                  );
                }

                final rooms = snapshot.data!;
                
                // Filter berdasarkan dropdown jika memilih selain 'Semua'
                final filtered = rooms.where((r) {
                  if (_selectedFilter == 'Terisi') return r['status'] == 'Terisi';
                  if (_selectedFilter == 'Kosong') return r['status'] == 'Tersedia';
                  return true;
                }).toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isDesktop ? 1.4 : 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final room = filtered[index];
                    // Konversi map API ke RoomModel sederhana jika widget RoomCard butuh object RoomModel
                    final roomModel = RoomModel(
                      id: room['id'].toString(),
                      name: room['nomor'],
                      price: 'Rp ${room['harga']}',
                      isAvailable: room['status'] == 'Tersedia',
                    );

                    return RoomCard(
                      room: roomModel,
                      onStatusChanged: () {
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),

            // ================= 3. DAFTAR TAGIHAN & WA =================
            const Text(
              'Daftar Tagihan & Jatuh Tempo',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
           FutureBuilder<List<dynamic>>(
              future: ApiService.fetchPenghuniKamar(), // Pastikan method ini ada di ApiService
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat tagihan: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white)),
                  );
                }

                // Filter hanya kamar yang 'Terisi' (punya penghuni)
                final occupied = (snapshot.data ?? [])
                    .where((r) => r['status'] == 'Terisi')
                    .toList();

                if (occupied.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Tidak ada tagihan aktif',
                        style: TextStyle(color: Colors.white70)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: occupied.length,
                  itemBuilder: (context, index) {
                    final item = occupied[index];
                    return Card(
                      color: const Color(0xFF1A222D),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long, color: Colors.orange),
                        title: Text(
                          '${item['nama_penghuni']} (${item['nomor_kamar']})',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Nominal: Rp ${item['harga']} | Jatuh Tempo: Tanggal 10',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.2),
                            foregroundColor: Colors.green,
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.chat, size: 16),
                          label: const Text('Kirim WA'),
                          onPressed: () => _showWADialog(
                            item['nama_penghuni'],
                            item['nomor_kamar'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),

            // ================= 4. TABEL RIWAYAT TRANSAKSI =================
            const Text(
              'Riwayat Transaksi Terakhir',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A222D),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: rooms.expand((room) => room.historyPembayaran.map((hist) {
                      return ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text('${hist.nama} - ${room.name}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        subtitle: Text('${hist.bulan} • Tgl: ${hist.tglTransfer}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        trailing: Text('Rp ${hist.nominal}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      );
                    })).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A222D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}