import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/Kurir.dart';
import '../shared/theme.dart';
import '../util/user_data_manager.dart';
import 'HomePage.dart';

// Halaman profil untuk kurir, menampilkan informasi kurir dan opsi untuk logout
class ProfilePage extends StatelessWidget {
  final Kurir kurir;

  // Konstruktor untuk menerima objek kurir
  const ProfilePage({Key? key, required this.kurir}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Menampilkan gambar profil kurir
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/johndoe.png'),
            ),
            SizedBox(height: 16),
            // Menampilkan nama lengkap kurir
            Text(
              kurir.namaLengkap ?? 'Unknown',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            // Tombol logout
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

  // Fungsi untuk menangani proses logout
  void _logout(BuildContext context) async {
    // Menghapus data pengguna yang tersimpan
    await UserDataManager.clearUserData();
    // Menavigasi pengguna kembali ke halaman login dan menghapus semua riwayat halaman
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  // Fungsi untuk membangun BottomNavigationBar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // Menetapkan item kedua (Akun) sebagai yang dipilih
      onTap: (index) {
        if (index == 0) {
          // Menavigasi ke HomePage jika item pertama dipilih
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(kurir: kurir)),
          );
        }
        // Jika index adalah 1, kita sudah berada di halaman ProfilePage, jadi tidak melakukan apa-apa
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
