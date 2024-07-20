import 'package:flutter/material.dart';
import '../model/Pengantaran.dart';
import '../shared/theme.dart';
import 'RouteCard.dart';
import '../model/DetailPengantaran.dart';

class PengantaranPage extends StatelessWidget {
  final List<Pengantaran> pengantaran;
  final String status;
  final String kurirId; // Ubah tipe data menjadi String untuk konsistensi

  PengantaranPage({
    required this.pengantaran,
    required this.status,
    required this.kurirId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildRutePengantaranContent(context, pengantaran),
    );
  }

  Widget _buildRutePengantaranContent(BuildContext context, List<Pengantaran> pengantaran) {
    List<DetailPengantaran> filteredDetails = pengantaran
        .expand((pengantaran) => pengantaran.detailPengantaran)
        .where((detail) => detail.status == status)
        .toList();

    if (filteredDetails.isEmpty) {
      return Center(
        child: Text(
          status == 'pending'
              ? 'Tidak ada pengantaran yang pending.'
              : 'Tidak ada pengantaran yang sudah dikirim.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredDetails.length,
      itemBuilder: (context, index) {
        final detail = filteredDetails[index];
        int ruteNumber = index + 1;
        return RouteCard(
          routeName: "Rute $ruteNumber",
          noResi: detail.noResi,
          name: detail.namaPenerima,
          phone: detail.nohp,
          address: detail.alamatPenerima,
          latitude: detail.latitude,
          longitude: detail.longitude,
          kurirId: kurirId,
          bgColor: status == 'pending' ? Colors.yellow[100] : Colors.green[100],
          detailPengantaran: detail, // Tambahkan ini
        );
      },
    );
  }
}