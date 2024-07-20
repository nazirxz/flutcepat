import 'package:flutter/material.dart';
import 'MapPage.dart';

class RouteCard extends StatelessWidget {
  final String routeName;
  final String noResi;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final int kurirId; // Ubah tipe data menjadi int
  final Color? bgColor;

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                        routeName: routeName,
                        latitude: latitude,
                        longitude: longitude,
                        kurirId: kurirId.toString(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "Lihat Rute",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Action to view delivery status
                  print('Status Pengantaran: $routeName');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "Status Pengantaran",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}