import 'package:flutter/material.dart';
import 'package:sicepat/shared/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15
        ),
        children:  [
          Container(
            margin: const EdgeInsets.only(
              top: 50
              ),
          ),
           Row(
            children: [
              Text(
                'Login',
                style: outfitBold.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Fix typo: bold should be FontWeight.bold
                ),
              ),
              const SizedBox(width: 5),
              SvgPicture.asset(
                'assets/User.svg', // Provide the path to your SVG asset
                width: 24, // Adjust width and height as needed
                height: 24,
              ),
            ],
          ),
          const SizedBox(height: 10), // Add some space between "Login" and "Good Morning"
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
          )
          
        ],        
      ),

    );
  }
}