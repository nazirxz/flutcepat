import 'package:flutter/material.dart';
import 'package:sicepat/ui/home_page.dart';
import 'package:sicepat/ui/login.dart';
import 'package:sicepat/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sicepat',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      //   useMaterial3: true
      // ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/login':(context) => const LoginPage(),
        '/home':(context) => const HomePage(),
      },
    );
  }
}