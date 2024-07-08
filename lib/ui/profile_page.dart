import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Kurir.dart';

class profile_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    Kurir kurir = Kurir(id: 0, namaLengkap: "", nohp: "", username: "", password: "", region: "", noPolisi: "");

    if (args != null && args is Map<String, dynamic>) {
      kurir = args['kurir'] as Kurir;
    }

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
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('kurir'); // Hapus data kurir
    await prefs.remove('pengantaran'); // Hapus data pengantaran

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }
}
