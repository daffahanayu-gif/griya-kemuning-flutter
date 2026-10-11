import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Import ApiService & Model Kamar kamu di sini
import '/service/api_service.dart'; // import '../services/api_service.dart';
import '/models/room_model.dart'; // import '../models/kamar_model.dart';

class ReservationForm extends StatefulWidget {
  const ReservationForm({Key? key}) : super(key: key);

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String? _selectedKamar;
  late Future<List<dynamic>> _futureKamar;

  final String _adminWhatsApp = "6281370709330"; // Masukkan nomor WA Admin

  @override
  void initState() {
    super.initState();
    // Panggil API kamar saat widget di-load
    // Sesuaikan dengan method ApiService kamu, misal: ApiService().getKamar()
    _futureKamar = ApiService.fetchKamar(); 
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _submitAndRedirectWA() async {
  if (_formKey.currentState!.validate()) {
    // 1. Kirim data reservasi ke Database via ApiService
    // Jika _selectedKamar bernilai "Kamar 02 (Tersedia)" atau "Kamar 02"
    String nomorClean = _selectedKamar!.replaceAll(' (Tersedia)', '').trim();

    bool success = await ApiService().tambahPenghuni(
      nama: _namaController.text,
      noHp: _noHpController.text,
      nomorKamar: nomorClean, // Kirim "Kamar 02" murni
      tanggalMasuk: _tanggalController.text,
      email: _emailController.text, // tambahkan email jika backend minta
    );

    if (success) {
      // 2. Jika sukses disimpan ke MySQL, buka WhatsApp
      final textWA = "Halo Admin, saya ingin reservasi kamar:\n"
          "Nama: ${_namaController.text}\n"
          "No HP: ${_noHpController.text}\n"
          "Kamar: $_selectedKamar\n"
          "Tanggal Masuk: ${_tanggalController.text}";

      final url = Uri.parse("https://api.whatsapp.com/send/?phone=$_adminWhatsApp&text=${Uri.encodeComponent(textWA)}");
      
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }

      // 3. Tampilkan pesan sukses dan refresh halaman
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservasi berhasil disimpan & diteruskan ke WA!')),
        );
        setState(() {}); // Refresh UI agar status kamar ter-update
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan reservasi ke database!')),
        );
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "SECURE YOUR SPACE",
                style: TextStyle(
                  color: Color(0xFFA1824A),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Formulir Reservasi Digital",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Nama Lengkap
              TextFormField(
                controller: _namaController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Nama lengkap wajib diisi!';
                  if (value.trim().length < 3) return 'Nama minimal 3 karakter!';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Nomor WhatsApp
              TextFormField(
                controller: _noHpController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  hintText: '081234567890',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Nomor WhatsApp wajib diisi!';
                  if (!RegExp(r'^(^\+62|62|^08)[0-9]{8,11}$').hasMatch(value.trim())) {
                    return 'Format nomor HP/WA tidak valid!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Alamat Email / Gmail',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Alamat email wajib diisi!';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                    return 'Format email tidak valid!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Tanggal Masuk
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Rencana Tanggal Masuk',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFFA1824A)),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Tanggal masuk wajib dipilih!';
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _tanggalController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // 5. DROPDOWN KAMAR DENGAN FUTUREBUILDER
              FutureBuilder<List<dynamic>>(
                future: _futureKamar,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(color: Color(0xFFA1824A)),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Gagal memuat daftar kamar',
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  final listKamar = snapshot.data ?? [];

                  if (listKamar.isEmpty) {
                    return const Text('Tidak ada data kamar tersedia');
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedKamar,
                    style: const TextStyle(color: Colors.black87),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Pilih Kamar',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: listKamar.map<DropdownMenuItem<String>>((kamar) {
                      // 1. Ambil nomor kamar sesuai kolom 'nomor' di MySQL database
                      String nomorKamar = kamar['nomor']?.toString() ?? 'Kamar';

                      // 2. Cek status ketersediaan ('Tersedia' / 'Terisi')
                      String statusRaw = (kamar['status'] ?? '').toString();
                      bool isTersedia = statusRaw.toLowerCase() == 'tersedia';
                      
                      String labelStatus = isTersedia ? ' (Tersedia)' : ' (Terisi - Penuh)';

                      return DropdownMenuItem<String>(
                        value: isTersedia ? nomorKamar : null, // Jika terisi, tidak bisa dipilih
                        enabled: isTersedia,                 // Opsi otomatis dimatikan jika penuh
                        child: Text(
                          "$nomorKamar$labelStatus",
                          style: TextStyle(
                            color: isTersedia ? Colors.black87 : Colors.grey,
                            fontWeight: isTersedia ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedKamar = newValue;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Silakan pilih kamar yang tersedia!';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 28),

              // 6. Tombol Submit
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitAndRedirectWA,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA1824A),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'KIRIM RESERVASI VIA WA',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}