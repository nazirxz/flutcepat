import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sicepat/shared/theme.dart';


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
      Navigator.pushNamedAndRemoveUntil(
        context,'/login',
        (route)=> false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          width: 139,
          height: 147,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/logo.png'))
          ),
        ),
      ),


    );
  }
}