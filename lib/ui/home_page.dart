import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sicepat/shared/theme.dart';
import 'package:sicepat/ui/profile_page.dart';

import '../model/Kurir.dart';
import '../model/Pengantaran.dart';

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

  final List<Widget> _pages = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Kurir kurir = args['kurir'];
    final List<Pengantaran> pengantaran = args['pengantaran'];

    _pages.clear();
    _pages.addAll([
      PengantaranPage(pengantaran: pengantaran),
      profile_page(),
    ]);

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

class PengantaranPage extends StatelessWidget {
  final List<Pengantaran> pengantaran;

  PengantaranPage({required this.pengantaran});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Rute"),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.signal_cellular_alt, color: Colors.black),
                  SizedBox(width: 10),
                  Icon(Icons.battery_full, color: Colors.black),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            labelColor: redColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: redColor,
            tabs: [
              Tab(text: 'Rute Pengantaran'),
              Tab(text: 'Riwayat Pengantaran'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRutePengantaranContent(context, pengantaran),
            // Konten untuk tab Riwayat Pengantaran (tambahkan di sini)
          ],
        ),
      ),
    );
  }

  Widget _buildRutePengantaranContent(BuildContext context, List<Pengantaran> pengantaran) {
    return ListView.builder(
      itemCount: pengantaran.length,
      itemBuilder: (context, index) {
        final item = pengantaran[index];
        return RouteCard(
          routeName: "Rute ${index + 1}",
          noResi: item.detailPengantaran[0].id.toString(),
          name: item.detailPengantaran[0].namaPenerima,
          phone: item.detailPengantaran[0].nohp,
          address: item.detailPengantaran[0].alamatPenerima,
          bgColor: Colors.yellow[100],
        );
      },
    );
  }
}

class RouteCard extends StatelessWidget {
  final String routeName;
  final String noResi;
  final String name;
  final String phone;
  final String address;
  final Color? bgColor;

  RouteCard({
    required this.routeName,
    required this.noResi,
    required this.name,
    required this.phone,
    required this.address,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            routeName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("No Resi: $noResi"),
          SizedBox(height: 8),
          Text("Nama: $name"),
          Text("No HP: $phone"),
          Text("Alamat: $address"),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text("Lihat Rute"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text("Status Pengantaran"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
