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
          horizontal: 20
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
          ),

          const SizedBox(height: 40),

          //INPUT FIELD

          //Input Username
          Text(
            'Username',
            style: poppinBold.copyWith(
              fontSize: 17,
              fontWeight: bold
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            contentPadding: const EdgeInsets.all(12)
            ),
          ),
          const SizedBox(height: 20),

          //Input Password
           Text(
            'Password',
            style: poppinBold.copyWith(
              fontSize: 17,
              fontWeight: bold
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding: const EdgeInsets.all(12)
            ),
          ),
          
          //BUTTON LOGIN
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: (){},
              style: TextButton.styleFrom(
                backgroundColor: redColor,
                
              ), 
              child: Text(
                'Login',
                style: poppinsboldWhite.copyWith(
                  fontSize: 15,
                  fontWeight: bold
                ),
                ),
            ),
          ),
          const SizedBox(height: 150),
          Align(
            child: Text('PT. Sicepat Payung Sekaki',
            style: outfitBold,

          )
          )
          
        ],        
      ),

    );
  }
}