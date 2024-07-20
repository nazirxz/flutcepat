import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sicepat/ui/ProfilePage.dart';
import '../model/Kurir.dart';
import '../model/Pengantaran.dart';
import '../service/ApiService.dart';
import '../shared/theme.dart';
import 'PengantaranPage.dart';

class HomePage extends StatefulWidget {
  final Kurir kurir;

  const HomePage({Key? key, required this.kurir}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pengantaran> _pengantaran = [];
  final ApiService _apiService = ApiService();
  int _currentIndex = 0;
  int _selectedView = 0; // 0 for Rute Pengantaran, 1 for Riwayat Pengantaran

  @override
  void initState() {
    super.initState();
    _fetchPengantaranData(widget.kurir.id.toString());
  }

  Future<void> _fetchPengantaranData(String kurirId) async {
    try {
      final List<Pengantaran> pengantarans = await _apiService.getPengantaranByKurir(kurirId);
      setState(() {
        _pengantaran = pengantarans;
      });
    } catch (e) {
      print('Error fetching pengantaran data: $e');
      // Handle error as needed
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchPengantaranData(widget.kurir.id.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            _buildButtonBar(),
            Expanded(
              child: PengantaranPage(
                pengantaran: _pengantaran,
                status: _selectedView == 0 ? 'pending' : 'delivered',
                kurirId: widget.kurir.id.toString(), // Convert int to String
                onRefreshData: _handleRefresh, // Ensure this is a valid Future<void> Function()
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTopBarButton(
          text: 'Rute Pengantaran',
          isSelected: _selectedView == 0,
          onTap: () {
            setState(() {
              _selectedView = 0;
            });
          },
        ),
        _buildTopBarButton(
          text: 'Riwayat Pengantaran',
          isSelected: _selectedView == 1,
          onTap: () {
            setState(() {
              _selectedView = 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTopBarButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? redColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : redColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(kurir: widget.kurir),
            ),
          );
        } else {
          setState(() {
            _currentIndex = index;
            _selectedView = 0; // Ensure the view switches to Rute Pengantaran
          });
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon_nav_1.svg',
            width: 24,
            height: 24,
            color: _currentIndex == 0 ? redColor : grayColor,
          ),
          label: 'Rute Pengantaran',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/User.svg',
            width: 24,
            height: 24,
            color: _currentIndex == 1 ? redColor : grayColor,
          ),
          label: 'Akun',
        ),
      ],
    );
  }
}
