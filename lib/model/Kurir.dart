class Kurir {
  int id;
  String namaLengkap;
  String nohp;
  String username;
  String password;
  String region;
  String noPolisi;

  Kurir({
    required this.id,
    required this.namaLengkap,
    required this.nohp,
    required this.username,
    required this.password,
    required this.region,
    required this.noPolisi,
  });

  factory Kurir.fromJson(Map<String, dynamic> json) {
    return Kurir(
      id: int.parse(json['id'].toString()),
      namaLengkap: json['nama_lengkap'],
      nohp: json['nohp'].toString(), // Ubah menjadi string
      username: json['username'],
      password: json['password'],
      region: json['region'],
      noPolisi: json['no_polisi'].toString(), // Ubah menjadi string
    );
  }
}
