import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sicepat/shared/theme.dart';
import '../model/Kurir.dart';
import '../model/Pengantaran.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Center(child: Text('Home Page Content')), // Replace with your home page content
    profile_page(),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Kurir kurir = args['kurir'];
    final List<Pengantaran> pengantaran = args['pengantaran'];

    return Scaffold(
      backgroundColor: bgColor,
      body: _pages[_selectedIndex],
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
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? redColor : grayColor,
            ),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
