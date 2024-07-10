import 'package:flutter/material.dart';
import 'package:sicepat/model/Kurir.dart';
import 'package:sicepat/ui/HomePage.dart';
import 'package:sicepat/ui/login.dart';
import 'package:sicepat/ui/ProfilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurir App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) {
          final Kurir kurir = ModalRoute.of(context)?.settings.arguments as Kurir;
          return HomePage(kurir: kurir);
        },
        '/profile': (context) {
          final Kurir kurir = ModalRoute.of(context)?.settings.arguments as Kurir;
          return ProfilePage(kurir: kurir);
        },
      },
    );
  }
}
