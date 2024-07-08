import 'package:flutter/material.dart';
import 'package:sicepat/ui/home_page.dart';
import 'package:sicepat/ui/login.dart';
import 'package:sicepat/ui/splash_screen.dart';

import 'model/Kurir.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
        '/login': (context) => LoginPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          // Extract arguments passed via Navigator.pushNamed
          final args = settings.arguments;
          if (args is Kurir) {
            return MaterialPageRoute(
              builder: (context) => HomePage(kurir: args),
            );
          }
        }
        return null;
      },
    );
  }
}
