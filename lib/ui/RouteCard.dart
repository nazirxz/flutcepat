import 'package:flutter/material.dart';
import 'MapPage.dart';
import 'package:sicepat/model/DetailPengantaran.dart';

// Widget untuk menampilkan informasi detail pengantaran dalam bentuk kartu
class RouteCard extends StatelessWidget {
  final String routeName; // Nama rute pengantaran
  final String noResi; // Nomor resi pengiriman
  final String name; // Nama penerima
  final String phone; // Nomor telepon penerima
  final String address; // Alamat penerima
  final double latitude; // Latitude alamat penerima
  final double longitude; // Longitude alamat penerima
  final String kurirId; // ID kurir yang melakukan pengantaran
  final Color? bgColor; // Warna latar belakang kartu
  final DetailPengantaran detailPengantaran; // Detail informasi pengantaran
  final double distance; // Jarak dari posisi kurir ke alamat penerima
  final bool showRouteButton; // Menentukan apakah tombol "Lihat Rute" akan ditampilkan

  // Konstruktor untuk menerima semua parameter yang dibutuhkan
  RouteCard({
    required this.routeName,
    required this.noResi,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.kurirId,
    required this.bgColor,
    required this.detailPengantaran,
    required this.distance,
    required this.showRouteButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16), // Margin untuk kartu
      color: bgColor, // Warna latar belakang kartu
      child: Padding(
        padding: EdgeInsets.all(16), // Padding di dalam kartu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan nama rute
            Text(
              routeName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Menampilkan nomor resi
            Text("No Resi: $noResi"),
            SizedBox(height: 8),
            // Menampilkan nama penerima
            Text("Nama: $name"),
            // Menampilkan nomor telepon penerima
            Text("No HP: $phone"),
            // Menampilkan alamat penerima
            Text("Alamat: $address"),
            SizedBox(height: 8),
            // Menampilkan jarak dari kurir ke alamat penerima
            Text("Jarak: ${distance.toStringAsFixed(2)} km"),
            SizedBox(height: 8),
            // Menampilkan tombol "Lihat Rute" jika showRouteButton bernilai true
            if (showRouteButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman peta ketika tombol ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(
                            routeName: routeName,
                            latitude: latitude,
                            longitude: longitude,
                            kurirId: kurirId,
                            detailPengantaran: detailPengantaran,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Warna latar belakang tombol
                    ),
                    child: Text(
                      "Lihat Rute",
                      style: TextStyle(color: Colors.white), // Warna teks tombol
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
