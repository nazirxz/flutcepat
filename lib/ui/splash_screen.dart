import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sicepat/shared/theme.dart';

// Widget SplashScreen yang ditampilkan saat aplikasi pertama kali dibuka
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    // Menjalankan timer selama 2 detik sebelum navigasi ke halaman login
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context,
          '/login', // Navigasi ke halaman login
              (route) => false // Menghapus semua rute sebelumnya dari stack navigasi
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor, // Mengatur warna latar belakang layar
      body: Center(
        // Menampilkan logo di tengah layar
        child: Container(
          width: 139,
          height: 147,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logo.png'), // Menampilkan gambar logo
            ),
          ),
        ),
      ),
    );
  }
}
