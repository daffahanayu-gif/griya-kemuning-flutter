import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/room_model.dart';

class RoomDetailPage extends StatefulWidget {
  final RoomModel room;

  const RoomDetailPage({super.key, required this.room});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  // Controller untuk Form Catatan Servis
  final TextEditingController _catatanController = TextEditingController();

  // Controller untuk Form Edit Penghuni
  late TextEditingController _namaController;
  late TextEditingController _noHpController;
  late TextEditingController _tglMasukController;
  late bool _isAvailable;
  late String _statusLunas;

  // Inventaris Kamar (Dinamis)
  List<Map<String, String>> inventaris = [
    {'nama': 'Kasur Springbed', 'kondisi': 'Bagus'},
    {'nama': 'AC 1/2 PK', 'kondisi': 'Perlu Servis'},
    {'nama': 'Lemari Pakaian', 'kondisi': 'Bagus'},
    {'nama': 'Kunci Serep', 'kondisi': 'Tersedia'},
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.room.penghuni ?? '');
    _noHpController = TextEditingController(text: widget.room.noHp ?? '081234567890');
    _tglMasukController = TextEditingController(text: '10 Januari 2026');
    _isAvailable = widget.room.isAvailable;
    _statusLunas = 'Lunas';
  }

  // --- DIALOG EDIT DATA PENGHUNI & STATUS KAMAR ---
  void _editPenghuniDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A222D),
            title: const Text('Edit Data Penghuni', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Status Kamar Terisi', style: TextStyle(color: Colors.white)),
                    value: !_isAvailable,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setDialogState(() {
                        _isAvailable = !val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _namaController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nama Penghuni',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noHpController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'No. WhatsApp',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tglMasukController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Masuk',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _statusLunas,
                    dropdownColor: const Color(0xFF1A222D),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Status Tagihan Bulan Ini',
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                    items: ['Lunas', 'Belum Bayar', 'Jatuh Tempo']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => _statusLunas = val);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  setState(() {
                    // Update State Lokal
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Penghuni Berhasil Diperbarui!')),
                  );
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- DIALOG TAMBAH CATATAN SERVIS ---
  void _tambahCatatanDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A222D),
        title: const Text('Tambah Catatan Servis', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _catatanController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Contoh: Keran air bocor',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _catatanController.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              if (_catatanController.text.trim().isNotEmpty) {
                setState(() {
                  widget.room.catatanServis.add(_catatanController.text.trim());
                });
                _catatanController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // --- FUNGSI BUKA WHATSAPP ---
  void _bukaWA(String noHp, String nama, String roomName) async {
    String formattedPhone = noHp.replaceAll(RegExp(r'[^0-9]'), '');
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '62${formattedPhone.substring(1)}';
    }

    final String message = Uri.encodeComponent(
      'Halo $nama, ini Admin Griya Kemuning mengenai $roomName.',
    );
    final Uri waUrl = Uri.parse('https://web.whatsapp.com/send?phone=$formattedPhone&text=$message');

    if (await canLaunchUrl(waUrl)) {
      await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F141C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A222D),
        title: Text('Detail ${widget.room.name}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FOTO KAMAR ---
            Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 350),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/kamarkemuning.jpg.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF1A222D),
                        child: const Icon(Icons.king_bed, color: Colors.white38, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- HEADER & BADGE STATUS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.room.name,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${widget.room.price} / bulan',
                      style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isAvailable ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isAvailable ? 'Status: Kosong' : 'Status: Terisi',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- AKSI CEPAT ADMIN ---
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isAvailable
                        ? null
                        : () => _bukaWA(_noHpController.text, _namaController.text, widget.room.name),
                    icon: const Icon(Icons.chat, color: Colors.white, size: 18),
                    label: const Text('Hubungi WA', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _editPenghuniDialog,
                    icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
                    label: const Text('Edit Data', style: TextStyle(color: Colors.amber)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- INFORMASI PENGHUNI ---
            const Text(
              'Informasi Penghuni',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFF1A222D),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blueAccent),
                title: Text(
                  _isAvailable || _namaController.text.isEmpty ? 'Belum Ada Penghuni' : _namaController.text,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  _isAvailable
                      ? 'Kamar siap disewa'
                      : 'No. HP: ${_noHpController.text} • Jatuh Tempo: Tgl 10',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- STATUS SEWA & PEMBAYARAN ---
            const Text(
              'Status Sewa & Pembayaran',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A222D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStatusRow('Tanggal Masuk', _isAvailable ? '-' : _tglMasukController.text),
                  const Divider(color: Colors.white10),
                  _buildStatusRow('Periode Sewa', _isAvailable ? '-' : 'Bulanan'),
                  const Divider(color: Colors.white10),
                  _buildStatusRow('Status Bulan Ini', _isAvailable ? '-' : _statusLunas, isBadge: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- INVENTARIS KAMAR ---
            const Text(
              'Inventaris Kamar',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A222D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: inventaris.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['nama']!, style: const TextStyle(color: Colors.white70)),
                        Text(
                          item['kondisi']!,
                          style: TextStyle(
                            color: item['kondisi'] == 'Perlu Servis' ? Colors.orangeAccent : Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // --- CATATAN SERVIS / PERBAIKAN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Catatan Servis / Perbaikan',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _tambahCatatanDialog,
                  icon: const Icon(Icons.add_circle, color: Colors.amber),
                  tooltip: 'Tambah Catatan',
                ),
              ],
            ),
            const SizedBox(height: 10),
            widget.room.catatanServis.isEmpty
                ? const Text('Belum ada catatan perbaikan.', style: TextStyle(color: Colors.white54))
                : Column(
                    children: widget.room.catatanServis.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String catatan = entry.value;
                      return Card(
                        color: const Color(0xFF1A222D),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.build, color: Colors.amber),
                          title: Text(catatan, style: const TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () {
                              setState(() {
                                widget.room.catatanServis.removeAt(idx);
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, {bool isBadge = false}) {
    Color badgeColor = Colors.green;
    if (value == 'Belum Bayar') badgeColor = Colors.red;
    if (value == 'Jatuh Tempo') badgeColor = Colors.orange;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          isBadge && value != '-'
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: badgeColor.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: Text(value, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              : Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}