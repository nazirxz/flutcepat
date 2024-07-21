import 'package:flutter/material.dart';
import 'MapPage.dart';
import 'package:sicepat/model/DetailPengantaran.dart';

class RouteCard extends StatelessWidget {
  final String routeName;
  final String noResi;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final String kurirId;
  final Color? bgColor;
  final DetailPengantaran detailPengantaran;
  final double distance;
  final bool showRouteButton; // Add this parameter

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
    required this.distance,  // Add this parameter
    required this.showRouteButton, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.all(16),
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
            Text("Jarak: ${distance.toStringAsFixed(2)} km"),  // Display the distance
            SizedBox(height: 8),
            if (showRouteButton)
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
                            kurirId: kurirId,
                            detailPengantaran: detailPengantaran,
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
                ],
              ),
          ],
        ),
      ),
    );
  }
}
