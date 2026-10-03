import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../../providers/dummy/room_data.dart';
import 'roomdetail_page.dart';
import '../../service/api_service.dart';

class KamarPage extends StatefulWidget {
  const KamarPage({super.key});
  static const String tag = '/kamar';
  

  @override
  State<KamarPage> createState() => _KamarPageState();
}

class _KamarPageState extends State<KamarPage> {
  List<RoomModel> rooms = listKamarDummy;
  String _filter = 'Semua';

  List<RoomModel> get filteredRooms {
    if (_filter == 'Terisi') {
      return rooms.where((r) => !r.isAvailable).toList();
    } else if (_filter == 'Kosong') {
      return rooms.where((r) => r.isAvailable).toList();
    }
    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F141C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A222D),
        title: const Text('Manajemen Kamar', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF1A222D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter Status:', style: TextStyle(color: Colors.white70)),
                DropdownButton<String>(
                  value: _filter,
                  dropdownColor: const Color(0xFF1A222D),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: ['Semua', 'Terisi', 'Kosong']
                      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _filter = val);
                  },
                ),
              ],
            ),
          ),

          // List View Kamar dengan Gambar
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.fetchKamar(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat data: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data kamar',
                        style: TextStyle(color: Colors.white)),
                  );
                }

                final rooms = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final isAvailable = room['status'] == 'Tersedia';

                    return Card(
                      color: const Color(0xFF1A222D),
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Konversi data map ke RoomModel jika RoomDetailPage butuh RoomModel
                          // atau passing langsung variabel room-nya
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Gambar Kamar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/kamarkemuning.jpg.jpeg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.king_bed,
                                        color: Colors.white54, size: 40),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Detail Teks Kamar dari Database MySQL
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      room['nomor'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${room['harga']}',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      room['deskripsi'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status Badge (Tersedia / Terisi)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  room['status'] ?? '',
                                  style: TextStyle(
                                    color: isAvailable ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}