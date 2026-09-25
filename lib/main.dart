import 'package:flutter/material.dart';

// =========================================================
// 1. IMPORTS VIEW MODULES
// =========================================================

// Views Admin Management
import 'views/admin/login_page.dart';
import 'views/admin/home_page.dart';
import 'views/admin/kamar_page.dart';
import 'views/admin/profile_page.dart';

// View Public (Landing Page Calon Penghuni)
import 'views/public/landing_page.dart';

// =========================================================
// 2. ENTRY POINT
// =========================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// =========================================================
// 3. MAIN APPLICATION CONFIGURATION
// =========================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuration Basic
      title: 'Griya Kemuning',
      debugShowCheckedModeBanner: false,

      // -----------------------------------------------------
      // GLOBAL APP THEME CONFIGURATION
      // -----------------------------------------------------
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD4AF37), // Gold Kemuning
        scaffoldBackgroundColor: const Color(0xFF12181F), // Dark Navy
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFD4AF37),
          surface: Color(0xFF1A222D),
          background: Color(0xFF12181F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A222D),
          elevation: 0,
        ),
        fontFamily: 'Roboto', // Default Font
      ),

      // -----------------------------------------------------
      // ROUTING CONFIGURATION
      // -----------------------------------------------------
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/kamar': (context) => const KamarPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}