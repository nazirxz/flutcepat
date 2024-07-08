import 'package:flutter/material.dart';
import '../model/Pengantaran.dart';
import '../shared/theme.dart';
import 'RouteCard.dart';

class PengantaranPage extends StatelessWidget {
  final List<Pengantaran> pengantaran;

  PengantaranPage({required this.pengantaran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
        ],
      ),
      body: _buildRutePengantaranContent(context, pengantaran),
    );
  }

  Widget _buildRutePengantaranContent(BuildContext context, List<Pengantaran> pengantaran) {
    return ListView.builder(
      itemCount: pengantaran.length,
      itemBuilder: (context, index) {
        final item = pengantaran[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: item.detailPengantaran.map((detail) {
            return RouteCard(
              routeName: "Rute ${index + 1}",
              noResi: detail.id.toString(),
              name: detail.namaPenerima,
              phone: detail.nohp,
              address: detail.alamatPenerima,
              bgColor: Colors.yellow[100],
            );
          }).toList(),
        );
      },
    );
  }
}
