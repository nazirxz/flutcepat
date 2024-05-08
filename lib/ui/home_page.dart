import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sicepat/shared/theme.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: redColor,
        unselectedItemColor: grayColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
            'assets/icon_nav_1.svg',
            width: 10,
            height: 30,
            color: redColor,
            ),
            
            label: 'Rute Pengantaran',
          ),
            BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/User.svg',
            width: 10,
            height: 30,
            ),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}