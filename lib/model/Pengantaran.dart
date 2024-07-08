import 'DetailPengantaran.dart';

class Pengantaran {
  final int id;
  final String region;
  final int kurirId;
  final int jumlahPaket;
  final List<DetailPengantaran> detailPengantaran;

  Pengantaran({
    required this.id,
    required this.region,
    required this.kurirId,
    required this.jumlahPaket,
    required this.detailPengantaran,
  });

  factory Pengantaran.fromJson(Map<String, dynamic> json) {
    print("Parsing Pengantaran: $json"); // Log for debugging
    var list = json['detail_pengantaran'] as List;
    List<DetailPengantaran> detailList = list.map((i) => DetailPengantaran.fromJson(i)).toList();

    return Pengantaran(
      id: int.parse(json['id'].toString()), // Ensure id is parsed as int
      region: json['region'],
      kurirId: int.parse(json['kurir_id'].toString()), // Ensure kurir_id is parsed as int
      jumlahPaket: int.parse(json['jumlah_paket'].toString()), // Ensure jumlah_paket is parsed as int
      detailPengantaran: detailList,
    );
  }
}