import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Catatan URL:
  // - Jika pakai Web / Windows App: 'http://localhost:3000/api'
  // - Jika pakai Android Emulator: 'http://10.0.2.2:3000/api'
  // - Jika pakai HP Fisik via WiFi: 'http://IP_LAPTOP_KAMU:3000/api'
  static const String baseUrl = 'https://griya-kemuning-flutter.vercel.app/api';
  

  // Fetch daftar kamar dari MySQL
  static Future<List<dynamic>> fetchKamar() async {
    final response = await http.get(Uri.parse('$baseUrl/kamar'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Gagal mengambil data kamar');
    }
  }

  static Future<List<dynamic>> fetchPenghuniKamar() async {
    final response = await http.get(Uri.parse('$baseUrl/penghuni-kamar'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Gagal mengambil data penghuni');
    }
  }

  Future<bool> tambahPenghuni({
  required String nama,
  required String noHp,
  required String nomorKamar,
  required String tanggalMasuk,
  String? email
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/penghuni'), // ganti sesuai endpoint backend kamu
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'no_hp': noHp,
          'nomor_kamar': nomorKamar,
          'tanggal_masuk': tanggalMasuk,
          'email': email,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error tambah penghuni: $e');
      return false;
    }
  }
}

