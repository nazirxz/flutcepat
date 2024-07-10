import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'package:sicepat/shared/theme.dart';
import 'package:sicepat/widget/buttons.dart';
import '../service/ApiService.dart';
import '../model/Kurir.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password are required')),
      );
      return;
    }

    try {
      final result = await _apiService.login(username, password);

      developer.log("Login Result: $result");

      if (result != null && result['status'] == 'success') {
        Kurir kurir = Kurir.fromJson(result['kurir']);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('lastLoggedInUsername', username);
        await prefs.setBool(username, true);

        final kurirJson = json.encode(kurir.toJson());
        await prefs.setString(username, kurirJson);

        Navigator.pushReplacementNamed(context, '/home', arguments: kurir);
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
            SvgPicture.asset(
              'assets/login_illustration.svg',
              width: 257,
              height: 236,
            ),
            const SizedBox(height: 40),
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
            CustomFilledButton(
              title: 'Login',
              onPressed: _login,
            ),
            const SizedBox(height: 150),
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