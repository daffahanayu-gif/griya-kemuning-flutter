import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dummy/room_data.dart';

// Import model dan provider
import '../models/room_model.dart';
import '../providers/dummy/room_data.dart';

class HeroBanner extends StatefulWidget {
  final VoidCallback? onExplorePressed;

  const HeroBanner({
    super.key,
    this.onExplorePressed,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _currentHeroIndex = 0;
  Timer? _timer;
  final List<String> _heroImages = [
    'assets/depanGK2.jpg',
    'assets/depanGK.jpg.jpeg',
    'assets/lantaiGK2.jpg.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentHeroIndex = (_currentHeroIndex + 1) % _heroImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

void _showKetersediaanDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      final listKamar = listKamarDummy;

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFFFF8F9FA), // Latar terang sesuai tema
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUS KETERSEDIAAN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB5945B),
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ketersediaan Kamar Kos',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFF222222), // Teks gelap
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Indikator Warna
              Row(
                children: const [
                  CircleAvatar(radius: 5, backgroundColor: Colors.green),
                  SizedBox(width: 6),
                  Text('Tersedia', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  SizedBox(width: 20),
                  CircleAvatar(radius: 5, backgroundColor: Colors.redAccent),
                  SizedBox(width: 6),
                  Text('Terisi (Full)', style: TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black12),
              const SizedBox(height: 12),

              // Grid Status Kamar
              Expanded(
                child: listKamar.isEmpty
                    ? const Center(
                        child: Text('Belum ada data kamar', style: TextStyle(color: Colors.black54)),
                      )
                    : SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: listKamar.length,
                          itemBuilder: (context, index) {
                            final room = listKamar[index];
                            final bool isAvailable = room.isAvailable;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? Colors.green.withOpacity(0.08)
                                    : Colors.redAccent.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isAvailable ? Colors.green : Colors.redAccent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        room.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 13, 
                                          color: Color(0xFF222222),
                                        ),
                                      ),
                                      Text(
                                        'Rp ${room.price}',
                                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isAvailable ? Colors.green : Colors.redAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isAvailable ? 'Tersedia' : 'Terisi',
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB5945B),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('TUTUP', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: double.infinity,
      color: const Color(0xFF222222),
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: Container(
              key: ValueKey<int>(_currentHeroIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_heroImages[_currentHeroIndex]),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.55), BlendMode.darken),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'WELCOME TO ELITE LIVING',
                    style: TextStyle(color: Color(0xFFB5945B), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Kebahagiaan Istirahat Maksimal\ndalam Kemewahan yang Privat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hunian eksklusif dengan sentuhan minimalis modern bernuansa resort mewah Bali.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onExplorePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB5945B),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        child: const Text('EXPLORE ROOM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      OutlinedButton(
                        onPressed: () => _showKetersediaanDialog(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        child: const Text('CEK KETERSEDIAAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}