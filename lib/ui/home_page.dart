import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sicepat/shared/theme.dart';
import 'package:sicepat/widget/map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MapScreen(), // Map Screen for the first tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: redColor,
        unselectedItemColor: grayColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon_nav_1.svg',
              width: 24,
              height: 24,
              color: _selectedIndex == 0 ? redColor : grayColor,
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
