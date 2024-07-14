import 'DetailPengantaran.dart';

class Pengantaran {
  static Pengantaran? _instance;
  final String id;
  final String region;
  final String kurirId;
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
    var detailList = json['detail_pengantaran'] as List;
    List<DetailPengantaran> detailPengantaranList =
    detailList.map((data) => DetailPengantaran.fromJson(data)).toList();

    return Pengantaran(
      id: json['id'],
      region: json['region'],
      kurirId: json['kurir_id'],
      jumlahPaket: int.parse(json['jumlah_paket']),
      detailPengantaran: detailPengantaranList,
    );
  }
  static void resetInstance() {
    _instance = null;
  }
}
