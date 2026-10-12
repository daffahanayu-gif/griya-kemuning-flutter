import 'package:flutter/material.dart';
import '../../widgets/hero_banner.dart';
import '../../widgets/signature_room.dart';
import '../../widgets/facility_card.dart';
import '../../widgets/reservation_form.dart';
import '../admin/login_page.dart';
import 'dart:ui_web' as ui_web;
import 'package:universal_html/html.dart' as html;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey _roomKey = GlobalKey();
  final GlobalKey _reservationKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'GRIYA KEMUNING',
          style: TextStyle(letterSpacing: 2, color: Color(0xFF222222), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('LOGIN', style: TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: () => _scrollToSection(_reservationKey),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB5945B)),
              child: const Text('BOOK NOW', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [           
            HeroBanner(
              onExplorePressed: () => _scrollToSection(_roomKey),
            ),
            SignatureRoom(key: _roomKey),
            const FacilityCard(),
            ReservationForm(key: _reservationKey),
            
            // FOOTER INFORMATIF
            Container(
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              width: double.infinity,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 40,
                        runSpacing: 24,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 280,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('GRIYA KEMUNING', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                SizedBox(height: 8),
                                Text(
                                  'Kawasan Hunian Co-Living Eksklusif yang tenang, aman, dan berkelas dengan standar kenyamanan modern.',
                                  style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 280,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('HUBUNGI KAMI', style: TextStyle(color: Color(0xFFB5945B), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                SizedBox(height: 10),
                                Text('📍 Jl. Kemuning No.16, Bangunsari, Kec. Mejayan, Kabupaten Madiun, Jawa Timur 63153', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                SizedBox(height: 6),
                                Text('📞 WhatsApp: +62 813-7070-9330', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                SizedBox(height: 6),
                                Text('📞 WhatsApp: +62 896-6660-0001', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                SizedBox(height: 6),
                                Text('✉️ Email: info@griyakemuning.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const GoogleMapFooter(),
                      const SizedBox(height: 30),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 12),
                      const Text('© 2026 Griya Kemuning Hub. All Rights Reserved.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class GoogleMapFooter extends StatefulWidget {
  const GoogleMapFooter({super.key});

  @override
  State<GoogleMapFooter> createState() => _GoogleMapFooterState();
}

class _GoogleMapFooterState extends State<GoogleMapFooter> {
  final String viewType = 'google-maps-griya-kemuning';

  @override
  void initState() {
    super.initState();
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => html.IFrameElement()
        ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3954.2!2d111.65!3d-7.55!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e79bf0000000001%3A0x0!2sJl.%20Kemuning%20No.16%2C%20Bangunsari%2C%20Kec.%20Mejayan%2C%20Kabupaten%20Madiun!5e0!3m2!1sid!2sid!4v1700000000000!5m2!1sid!2sid'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: HtmlElementView(viewType: viewType),
    );
  }
}