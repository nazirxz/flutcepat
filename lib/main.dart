import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sicepat/model/Kurir.dart';
import 'package:sicepat/ui/HomePage.dart';
import 'package:sicepat/ui/LoginPage.dart';
import 'package:sicepat/ui/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final lastLoggedInUsername = prefs.getString('lastLoggedInUsername');
  final isLoggedIn = lastLoggedInUsername != null && prefs.getString(lastLoggedInUsername) != null; // Check if username exists as a key
  Kurir? kurir;

  if (isLoggedIn && lastLoggedInUsername != null) {
    final kurirData = prefs.getString(lastLoggedInUsername);
    if (kurirData != null) {
      final Map<String, dynamic> kurirMap = Map<String, dynamic>.from(json.decode(kurirData));
      kurir = Kurir.fromJson(kurirMap);
    } else {
      // Handle the case where kurir data is missing (e.g., logout the user)
      await prefs.remove('lastLoggedInUsername'); // Remove the username key to log out
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, kurir: kurir));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Kurir? kurir; // Make kurir nullable

  const MyApp({super.key, required this.isLoggedIn, this.kurir});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurir App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => kurir != null ? HomePage(kurir: kurir!) : LoginPage(),  // Check if kurir is not null
        '/profile': (context) => kurir != null ? ProfilePage(kurir: kurir!) : LoginPage(), // Check if kurir is not null
      },
    );
  }
}
