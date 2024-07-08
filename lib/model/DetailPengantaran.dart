class DetailPengantaran {
  final int id;
  final int pengantaranId;
  final String namaPenerima;
  final String nohp;
  final String alamatPenerima;
  final double latitude;
  final double longitude;
  final String tanggalPengantaran;

  DetailPengantaran({
    required this.id,
    required this.pengantaranId,
    required this.namaPenerima,
    required this.nohp,
    required this.alamatPenerima,
    required this.latitude,
    required this.longitude,
    required this.tanggalPengantaran,
  });

  factory DetailPengantaran.fromJson(Map<String, dynamic> json) {
    print("Parsing DetailPengantaran: $json"); // Log for debugging
    return DetailPengantaran(
      id: int.parse(json['id'].toString()), // Ensure id is parsed as int
      pengantaranId: int.parse(json['pengantaran_id'].toString()), // Ensure pengantaran_id is parsed as int
      namaPenerima: json['nama_penerima'],
      nohp: json['nohp'].toString(),
      alamatPenerima: json['alamat_penerima'],
      latitude: double.parse(json['latitude'].toString()), // Ensure latitude is parsed as double
      longitude: double.parse(json['longitude'].toString()), // Ensure longitude is parsed as double
      tanggalPengantaran: json['tanggal_pengantaran'],
    );
  }
}