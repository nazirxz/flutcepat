import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/DetailPengantaran.dart';
import '../model/Kurir.dart';
import '../model/Pengantaran.dart';
import '../shared/theme.dart';

class ProfilePage extends StatelessWidget {
  final Kurir kurir;

  const ProfilePage({Key? key, required this.kurir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/johndoe.png'),
            ),
            SizedBox(height: 16),
            Text(
              kurir.namaLengkap ?? 'Unknown',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear SharedPreferences

    // Reset all necessary models
    Kurir.resetInstance(); // Example reset for Kurir
    DetailPengantaran.resetInstance(); // If needed for DetailPengantaran
    Pengantaran.resetInstance(); // If needed for Pengantaran

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Navigate to Login page
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // Set to 0 for the first item (Rute Pengantaran)
      onTap: (index) {
        switch (index) {
          case 0:
          // Navigate to delivery routes or another appropriate screen
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
          // Stay on the current profile page (this page)
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon_nav_1.svg',
            width: 24,
            height: 24,
            color: grayColor,
          ),
          label: 'Rute Pengantaran',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/User.svg',
            width: 24,
            height: 24,
            color: redColor,
          ),
          label: 'Akun',
        ),
      ],
    );
  }
}

