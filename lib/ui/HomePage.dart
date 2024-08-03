import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/Pengantaran.dart';
import 'PengantaranPage.dart';
import '../model/Kurir.dart';
import '../service/ApiService.dart';
import '../shared/theme.dart';
import 'ProfilePage.dart';

// Halaman utama untuk kurir
class HomePage extends StatefulWidget {
  final Kurir kurir;

  const HomePage({Key? key, required this.kurir}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// State dari HomePage yang mengelola logika dan UI
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<Pengantaran> _pengantaran = []; // Daftar pengantaran
  final ApiService _apiService = ApiService(); // Instance dari ApiService untuk operasi API
  int _currentIndex = 0; // Indeks saat ini dari BottomNavigationBar
  int _selectedView = 0; // Indeks tampilan yang dipilih (0: Rute Pengantaran, 1: Riwayat Pengantaran)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Tambahkan observer untuk mendeteksi perubahan state aplikasi
    _fetchPengantaranData(widget.kurir.id.toString()); // Ambil data pengantaran saat inisialisasi
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hapus observer saat state ini dihancurkan
    super.dispose();
  }

  // Fungsi untuk menangani perubahan state lifecycle aplikasi
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchPengantaranData(widget.kurir.id.toString()); // Ambil data pengantaran saat aplikasi kembali aktif
    }
  }

  // Fungsi untuk mengambil data pengantaran dari API
  Future<void> _fetchPengantaranData(String kurirId) async {
    try {
      final List<Pengantaran> pengantarans = await _apiService.getPengantaranByKurir(kurirId);
      setState(() {
        _pengantaran = pengantarans; // Perbarui daftar pengantaran dengan data yang diterima
      });
    } catch (e) {
      print('Error fetching pengantaran data: $e');
    }
  }

  // Fungsi untuk menangani refresh data
  Future<void> _handleRefresh() async {
    await _fetchPengantaranData(widget.kurir.id.toString());
  }

  // Membangun UI halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Fungsi untuk menangani refresh
        child: Column(
          children: [
            _buildButtonBar(), // Bangun baris tombol untuk memilih tampilan
            Expanded(
              child: PengantaranPage(
                pengantaran: _pengantaran,
                status: _selectedView == 0 ? 'pending' : 'delivered', // Tentukan status pengantaran berdasarkan tampilan yang dipilih
                kurirId: widget.kurir.id.toString(), // Konversi int ke String
                onRefreshData: _handleRefresh, // Fungsi untuk menangani refresh
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), // Bangun BottomNavigationBar
    );
  }

  // Fungsi untuk membangun baris tombol di atas
  Widget _buildButtonBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTopBarButton(
          text: 'Rute Pengantaran',
          isSelected: _selectedView == 0,
          onTap: () {
            setState(() {
              _selectedView = 0; // Ubah tampilan ke Rute Pengantaran
            });
          },
        ),
        _buildTopBarButton(
          text: 'Riwayat Pengantaran',
          isSelected: _selectedView == 1,
          onTap: () {
            setState(() {
              _selectedView = 1; // Ubah tampilan ke Riwayat Pengantaran
            });
          },
        ),
      ],
    );
  }

  // Fungsi untuk membangun tombol baris atas
  Widget _buildTopBarButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // Fungsi yang dipanggil saat tombol diklik
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? redColor : Colors.white, // Ubah warna berdasarkan apakah tombol dipilih atau tidak
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : redColor, // Ubah warna teks berdasarkan apakah tombol dipilih atau tidak
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun BottomNavigationBar
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
            _currentIndex = index; // Ubah indeks saat ini dari BottomNavigationBar
            _selectedView = 0; // Ubah tampilan ke Rute Pengantaran
          });
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icon_nav_1.svg',
            width: 24,
            height: 24,
            color: _currentIndex == 0 ? redColor : grayColor, // Ubah warna berdasarkan apakah item dipilih atau tidak
          ),
          label: 'Rute Pengantaran',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/User.svg',
            width: 24,
            height: 24,
            color: _currentIndex == 1 ? redColor : grayColor, // Ubah warna berdasarkan apakah item dipilih atau tidak
          ),
          label: 'Akun',
        ),
      ],
    );
  }
}
