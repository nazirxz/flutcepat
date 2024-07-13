import 'package:flutter/material.dart';
import '../model/Pengantaran.dart';
import '../shared/theme.dart';
import 'RouteCard.dart';
import '../model/DetailPengantaran.dart';

class PengantaranPage extends StatelessWidget {
  final List<Pengantaran> pengantaran;

  PengantaranPage({required this.pengantaran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildRutePengantaranContent(context, pengantaran),
    );
  }

  Widget _buildRutePengantaranContent(BuildContext context, List<Pengantaran> pengantaran) {
    // Filter pengantaran untuk hanya menampilkan yang statusnya "pending"
    List<DetailPengantaran> pendingDetails = pengantaran
        .expand((pengantaran) => pengantaran.detailPengantaran)
        .where((detail) => detail.status == 'pending')
        .toList();

    if (pendingDetails.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada pengantaran yang pending.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: pendingDetails.length,
      itemBuilder: (context, index) {
        final detail = pendingDetails[index];
        int ruteNumber = index + 1;
        return RouteCard(
          routeName: "Rute $ruteNumber", // Gunakan nomor rute yang benar
          noResi: detail.noResi,
          name: detail.namaPenerima,
          phone: detail.nohp,
          address: detail.alamatPenerima,
          bgColor: Colors.yellow[100],
        );
      },
    );
  }
}
