import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../service/api_service.dart';

class ReservasiPage extends StatefulWidget {
  const ReservasiPage({super.key});

  @override
  State<ReservasiPage> createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiPage> {
  List<dynamic> _listReservasi = [];
  bool _isLoading = true;

  // Sesuaikan URL jika menguji di Emulator Android (10.0.2.2) atau Web (localhost)
  final String baseUrl = 'http://127.0.0.1:3000/api';

  @override
  void initState() {
    super.initState();
    _fetchReservasi();
  }

  // 1. Ambil Data Reservasi dari Backend
  Future<void> _fetchReservasi() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Sesuaikan endpoint ini dengan endpoint GET penghuni/reservasi di index.js kamu
    final response = await http.get(Uri.parse('$baseUrl/penghuni'));

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          _listReservasi = json.decode(response.body);
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hindari spinner muter terus
        });
        _showSnackBar('Gagal mengambil data: Status ${response.statusCode}', isError: true);
      }
    }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hindari spinner muter terus
        });
        _showSnackBar('Error koneksi: $e', isError: true);
      }
    }
  }

  // 1. Fungsi Setujui Reservasi (dengan Log Debug)
  Future<void> _setujuiReservasi(int id) async {
  print('--> Memproses Setujui untuk ID Penghuni: $id');
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/reservasi/setujui/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      _showSnackBar('Reservasi berhasil disetujui!');
      _fetchReservasi();
    } else {
      _showSnackBar('Gagal: ${response.statusCode} - ${response.body}', isError: true);
    }
    } catch (e) {
      print('Error Catch: $e');
      _showSnackBar('Error koneksi: $e', isError: true);
    }
  }

// 2. Fungsi Batalkan Reservasi (dengan Log Debug)
  Future<void> _batalkanReservasi(int id) async {
  print('--> Memproses Batal untuk ID Penghuni: $id');
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/reservasi/batal/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      _showSnackBar('Reservasi berhasil dibatalkan!');
      _fetchReservasi();
    } else {
      _showSnackBar('Gagal: ${response.statusCode} - ${response.body}', isError: true);
    }
    } catch (e) {
      print('Error Catch: $e');
      _showSnackBar('Error koneksi: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[800] : Colors.green[800],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Disetujui':
        return Colors.green;
      case 'Batal':
        return Colors.red;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12181F),
      appBar: AppBar(
        title: const Text(
          'Persetujuan Reservasi',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E252B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFD4AF37)),
            onPressed: _fetchReservasi,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : _listReservasi.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada data reservasi.',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchReservasi,
                  color: const Color(0xFFD4AF37),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _listReservasi.length,
                    itemBuilder: (context, index) {
                      final item = _listReservasi[index];
                      // Gantilah baris 149 dengan ini:
                      final String status = (item['status'] ?? item['status_reservasi'] ?? 'Pending').toString();

                      return Card(
                        color: const Color(0xFF1E252B),
                        margin: const EdgeInsets.only(bottom: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['nama'] ?? 'Tanpa Nama',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(status).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: _getStatusColor(status)),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: _getStatusColor(status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('No. HP: ${item['no_hp'] ?? '-'}',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Email: ${item['email'] ?? '-'}',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Kamar ID: ${item['id_kamar'] ?? '-'}',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Tgl Masuk: ${item['tanggal_masuk'] ?? '-'}',
                                  style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 12),

                              // Tombol Aksi (Hanya tampil jika status masih 'Pending')
                              // Gantilah baris 207 dengan ini:
                              if (status.toLowerCase() == 'pending')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // === TOMBOL TOLAK ===
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        // Ambil ID dengan aman (cek 'id' atau 'id_penghuni')
                                        final dynamic rawId = item['id'] ?? item['id_penghuni'];
                                        if (rawId != null) {
                                          _batalkanReservasi(int.parse(rawId.toString()));
                                        }
                                      },
                                      icon: const Icon(Icons.close, color: Colors.red, size: 18),
                                      label: const Text('Tolak', style: TextStyle(color: Colors.red)),
                                    ),

                                    const SizedBox(width: 8),
                                    // === TOMBOL SETUJUI ACC ===
                                    ElevatedButton.icon(
                                    onPressed: () {
                                      // Ambil ID dengan aman (cek 'id' atau 'id_penghuni')
                                      final dynamic rawId = item['id'] ?? item['id_penghuni'];
                                      if (rawId != null) {
                                        _setujuiReservasi(int.parse(rawId.toString()));
                                      }
                                    },
                                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                                    label: const Text('Setujui ACC', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                                  ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}