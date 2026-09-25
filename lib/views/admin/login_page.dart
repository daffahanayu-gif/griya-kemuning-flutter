import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import '../public/landing_page.dart'; 

// ===========================================================================
// 1. login_page.dart
// ===========================================================================

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'adminkos@gmail.com');
  final _passwordController = TextEditingController(text: 'admin123');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF12181F), Color(0xFF1E252B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E252B).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo / Header
                  const CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/logo_gk2.png'), // Sesuaikan nama aset
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'GRIYA KEMUNING',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    'Exclusive Living Space',
                    style: TextStyle(color: Colors.white54, fontSize: 12.0),
                  ),
                  const SizedBox(height: 32.0),

                  // Field Email
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.email, color: Color(0xFFD4AF37)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Field Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFFD4AF37)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Ambil teks dari controller dan bersihkan spasi
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();

                        // 2. Cek validasi email & password
                        if (email == 'adminkos@gmail.com' && password == 'admin123') {
                          // Jika BENAR -> Pindah ke HomePage
                          Navigator.of(context).pushReplacementNamed(HomePage.tag);
                        } else {
                          // Jika SALAH -> Munculkan notifikasi kesalahan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Email atau Password salah, bung!'),
                                ],
                              ),
                              backgroundColor: Colors.red[800],
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tuliskan tombol Kembali ke Utama
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LandingPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 16,
                      color: Color(0xFFB5945B), // Warna emas khas Griya Kemuning
                    ),
                    label: const Text(
                      'Kembali ke Halaman Utama',
                      style: TextStyle(
                        color: Color(0xFFB5945B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}