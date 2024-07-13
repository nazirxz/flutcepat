class DetailPengantaran {
  final String id;
  final String pengantaranId;
  final String namaPenerima;
  final String nohp;
  final String alamatPenerima;
  final double latitude;
  final double longitude;
  final String tanggalPengantaran;
  final String noResi;
  final String status;

  DetailPengantaran({
    required this.id,
    required this.pengantaranId,
    required this.namaPenerima,
    required this.nohp,
    required this.alamatPenerima,
    required this.latitude,
    required this.longitude,
    required this.tanggalPengantaran,
    required this.noResi,
    required this.status,
  });

  factory DetailPengantaran.fromJson(Map<String, dynamic> json) {
    return DetailPengantaran(
      id: json['id'],
      pengantaranId: json['pengantaran_id'],
      namaPenerima: json['nama_penerima'],
      nohp: json['nohp'],
      alamatPenerima: json['alamat_penerima'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      tanggalPengantaran: json['tanggal_pengantaran'],
      noResi: json['no_resi'],
      status: json['status'],
    );
  }
}
