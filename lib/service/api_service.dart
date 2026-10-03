import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Catatan URL:
  // - Jika pakai Web / Windows App: 'http://localhost:3000/api'
  // - Jika pakai Android Emulator: 'http://10.0.2.2:3000/api'
  // - Jika pakai HP Fisik via WiFi: 'http://IP_LAPTOP_KAMU:3000/api'
  static const String baseUrl = 'http://localhost:3000/api';

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
}