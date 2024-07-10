class DetailPengantaran {
  final String id;
  final String pengantaranId;
  final String namaPenerima;
  final String nohp;
  final String alamatPenerima;
  final String latitude;
  final String longitude;
  final String tanggalPengantaran;
  final String noResi; // Tambahkan atribut no_resi

  DetailPengantaran({
    required this.id,
    required this.pengantaranId,
    required this.namaPenerima,
    required this.nohp,
    required this.alamatPenerima,
    required this.latitude,
    required this.longitude,
    required this.tanggalPengantaran,
    required this.noResi, // Inisialisasi no_resi dalam constructor
  });

  factory DetailPengantaran.fromJson(Map<String, dynamic> json) {
    return DetailPengantaran(
      id: json['id'],
      pengantaranId: json['pengantaran_id'],
      namaPenerima: json['nama_penerima'],
      nohp: json['nohp'],
      alamatPenerima: json['alamat_penerima'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      tanggalPengantaran: json['tanggal_pengantaran'],
      noResi: json['no_resi'], // Ambil no_resi dari JSON
    );
  }
}
