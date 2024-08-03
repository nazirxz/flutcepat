import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sicepat/model/Kurir.dart';
import 'package:sicepat/service/ApiService.dart';
import 'package:sicepat/shared/theme.dart';
import 'package:sicepat/widget/buttons.dart';
import '../ui/HomePage.dart';
import '../ui/ProfilePage.dart';
import 'dart:developer' as developer;

import '../util/user_data_manager.dart';

// LoginPage widget yang menggunakan StatefulWidget untuk mengelola keadaan
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengelola input dari pengguna
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  // Fungsi untuk menangani proses login
  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    // Validasi input: memeriksa apakah username atau password kosong
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password are required')),
      );
      return;
    }

    try {
      // Memanggil API untuk login
      final result = await _apiService.login(username, password);

      developer.log("Login Result: $result");

      // Memeriksa hasil login
      if (result != null && result['status'] == 'success') {
        Kurir kurir = Kurir.fromJson(result['kurir']);

        // Menghapus data pengguna sebelumnya dan menyimpan data pengguna baru
        await UserDataManager.clearUserData();
        await UserDataManager.saveUserData(kurir);

        // Navigasi ke HomePage dengan parameter kurir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(kurir: kurir)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      developer.log("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(height: 50),
            // Header login
            Row(
              children: [
                Text(
                  'Login',
                  style: outfitBold.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  'assets/User.svg',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Good Morning',
              style: poppinRegular.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // Ilustrasi login
            SvgPicture.asset(
              'assets/login_illustration.svg',
              width: 257,
              height: 236,
            ),
            const SizedBox(height: 40),
            // Label dan field input untuk username
            Text(
              'Username',
              style: poppinBold.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            // Label dan field input untuk password
            Text(
              'Password',
              style: poppinBold.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol custom untuk login
            CustomFilledButton(
              title: 'Login',
              onPressed: _login,
            ),
            const SizedBox(height: 150),
            // Footer
            Align(
              child: Text(
                'PT. Sicepat Payung Sekaki',
                style: outfitBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
