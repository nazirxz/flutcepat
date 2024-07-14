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
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  Kurir? kurir;

  if (isLoggedIn) {
    try {
      final kurirData = prefs.getString('kurirData');
      if (kurirData != null) {
        final Map<String, dynamic> kurirMap = json.decode(kurirData);
        kurir = Kurir.fromJson(kurirMap);
      }
    } catch (e) {
      print('Error decoding Kurir data: $e');
      kurir = null;
    }
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, kurir: kurir));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Kurir? kurir;

  const MyApp({Key? key, required this.isLoggedIn, this.kurir}) : super(key: key);

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
        '/home': (context) => isLoggedIn && kurir != null ? HomePage(kurir: kurir!) : LoginPage(),
        '/profile': (context) => isLoggedIn && kurir != null ? ProfilePage(kurir: kurir!) : LoginPage(),
      },
    );
  }
}
