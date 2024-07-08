import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sicepat/model/Kurir.dart';
import 'package:sicepat/model/Pengantaran.dart';
import 'package:sicepat/service/ApiService.dart';
import 'package:sicepat/shared/theme.dart';
import 'RouteCard.dart';
import 'PengantaranPage.dart';

class HomePage extends StatefulWidget {
  final Kurir kurir;

  const HomePage({Key? key, required this.kurir}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Pengantaran> _pengantaran = [];

  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPengantaranData(widget.kurir.id.toString()); // Pass Kurir ID
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchPengantaranData(String kurirId) async {
    try {
      List<Pengantaran> pengantarans = await _apiService.getPengantaranByKurir(kurirId);
      setState(() {
        _pengantaran = pengantarans;
      });
    } catch (e) {
      print('Error fetching pengantaran data: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Home'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Rute Pengantaran',
            ),
            Tab(
              text: 'Riwayat Pengantaran',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PengantaranPage(pengantaran: _pengantaran),
          _buildRiwayatPengantaran(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        selectedItemColor: redColor,
        unselectedItemColor: grayColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _tabController.index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon_nav_1.svg',
              width: 24,
              height: 24,
              color: _tabController.index == 0 ? redColor : grayColor,
            ),
            label: 'Rute Pengantaran',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/User.svg',
              width: 24,
              height: 24,
              color: _tabController.index == 1 ? redColor : grayColor,
            ),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatPengantaran() {
    return Center(
      child: Text(
        'Riwayat Pengantaran',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
