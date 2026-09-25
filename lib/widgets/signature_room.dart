import 'package:flutter/material.dart';

class SignatureRoom extends StatefulWidget {
  const SignatureRoom({super.key});

  @override
  State<SignatureRoom> createState() => _SignatureRoomState();
}

class _SignatureRoomState extends State<SignatureRoom> {
  int _currentRoomIndex = 0;
  final List<String> _roomImages = [
    'assets/kamar_deluxe.jpg.jpeg',
    'assets/kamarkemuning.jpg.jpeg',
    'assets/km2.jpg.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Column(
        children: [
          // HEADER SECTION
          const Text(
            'THE SANCTUARY',
            style: TextStyle(
              color: Color(0xFFB5945B),
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Signature Premium Room',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 2,
            color: const Color(0xFFB5945B),
          ),
          const SizedBox(height: 36),

          // MAIN CONTENT: FOTO DI KIRI, DESKRIPSI DI KANAN
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isDesktop = constraints.maxWidth > 700;

                  return Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SISI KIRI: SLIDER FOTO
                      Expanded(
                        flex: isDesktop ? 1 : 0,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      _roomImages[_currentRoomIndex],
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                // Tombol Panah Kiri
                                Positioned(
                                  left: 10,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white.withOpacity(0.8),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _currentRoomIndex = (_currentRoomIndex - 1 + _roomImages.length) % _roomImages.length;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Tombol Panah Kanan
                                Positioned(
                                  right: 10,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white.withOpacity(0.8),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.chevron_right, color: Colors.black87, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _currentRoomIndex = (_currentRoomIndex + 1) % _roomImages.length;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Gunakan tombol panah di atas untuk melihat sudut pandang kasur, TV, AC, dan Kamar Mandi',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ),

                      if (isDesktop) const SizedBox(width: 40) else const SizedBox(height: 24),

                      // SISI KANAN: DESKRIPSI & SPESIFIKASI
                      Expanded(
                        flex: isDesktop ? 1 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kenyamanan Tanpa Compromi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Every corner of the room is designed with care. Didesain menggunakan palet warna monokrom tenang, berpadu dengan furnitur minimalis kualitas premium. Pencahayaan alami yang melimpah membuat suasana kamar selalu segar sepanjang hari.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(color: Color(0xFFEEEEEE)),
                            const SizedBox(height: 12),

                            // GRID SPESIFIKASI 2 KOLOM
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpecItem('📐', 'LUAS KAMAR:', '4 X 4 M'),
                                ),
                                Expanded(
                                  child: _buildSpecItem('🛏️', 'KASUR:', 'PREMIUM SINGLE/QUEEN'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpecItem('🚿', 'KAMAR MANDI:', 'DALAM (MODERN)'),
                                ),
                                Expanded(
                                  child: _buildSpecItem('⚡', 'LISTRIK:', 'TOKEN MANDIRI'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: Color(0xFFEEEEEE)),
                            const SizedBox(height: 16),

                            // HARGA
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: const [
                                Text(
                                  'Rp 1.000.000',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '/ bulan (All-in Fasilitas Bersama)',
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String icon, String title, String value) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title ',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF444444)),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}