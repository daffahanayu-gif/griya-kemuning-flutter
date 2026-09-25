import 'package:flutter/material.dart';

class FacilityCard extends StatelessWidget {
  const FacilityCard({super.key});

  void _openFacilityModal(BuildContext context, String title, String desc, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup', style: TextStyle(color: Color(0xFFB5945B))),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
final List<Map<String, String>> listFasilitas = [
  {
    'tagline': 'Dingin & Sejuk',
    'title': 'Full AC',
    'img': 'assets/kamar_deluxe.jpg.jpeg',
    'desc': 'Setiap kamar dilengkapi AC hemat energi yang siap menjaga ruangan tetap sejuk.',
  },
  {
    'tagline': 'Aman & Terjaga',
    'title': 'CCTV 24 Jam',
    'img': 'assets/cctv2.jpg',
    'desc': 'Sistem keamanan IP Camera 24 jam di seluruh area publik untuk ketenangan Anda.',
  },
  {
    'tagline': 'Koneksi Tanpa Batas',
    'title': 'Wi-Fi High-Speed',
    'img': 'assets/wifi.jpg',
    'desc': 'Akses internet fiber optik kencang hingga 100 Mbps untuk kerja & hiburan.',
  },
  {
    'tagline': 'Serasa di Rumah',
    'title': 'Dapur Bersama',
    'img': 'assets/dapur2.jpg.jpeg',
    'desc': 'Dapur bersih dilengkapi dengan kulkas, kompor gas, dan dispenser air minum.',
  },
];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text('CURATED COMFORTS', style: TextStyle(color: Color(0xFFB5945B), fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Fasilitas Eksklusif Kos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF222222))),
          const SizedBox(height: 24),
          
          // Layout 4 Kolom Sejajar (Menggunakan LayoutBuilder & Wrap)
          LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = (constraints.maxWidth - (12 * 3)) / 4;
              if (cardWidth < 140) cardWidth = 140; // Batas minimal lebar HP

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
               children: listFasilitas.map((f) {
                return SizedBox(
                  width: cardWidth,
                  child: InkWell(
                    onTap: () => _openFacilityModal(
                      context, 
                      f['title'] ?? '', 
                      f['desc'] ?? '', 
                      f['img'] ?? '',
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Gunakan tagline tanpa tanda !
                          Text(
                            f['tagline'] ?? '', 
                            style: const TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFB5945B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            f['title'] ?? '', 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 12,
                            ), 
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Detail', 
                            style: TextStyle(
                              fontSize: 10, 
                              color: Color(0xFFFFB5945B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}