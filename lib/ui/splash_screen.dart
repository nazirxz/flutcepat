import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sicepat/shared/theme.dart';
import 'package:sicepat/ui/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 2), () { 
      Navigator.push(
        context, MaterialPageRoute(
          builder: (context) => const LoginPage()
          )
        );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          width: 239,
          height: 247,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/logo.png'))
          ),
        ),
      ),


    );
  }
}