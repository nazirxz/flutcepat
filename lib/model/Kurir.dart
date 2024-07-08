class Kurir {
  int? id;
  String? namaLengkap;
  String? nohp;
  String? username;
  String? password;
  String? region;
  String? noPolisi;

  Kurir({
    this.id,
    this.namaLengkap,
    this.nohp,
    this.username,
    this.password,
    this.region,
    this.noPolisi,
  });

  factory Kurir.fromJson(Map<String, dynamic> json) {
    return Kurir(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      namaLengkap: json['nama_lengkap'] as String?,
      nohp: json['nohp'] != null ? json['nohp'].toString() : null,
      username: json['username'] as String?,
      password: json['password'] as String?,
      region: json['region'] as String?,
      noPolisi: json['no_polisi'] != null ? json['no_polisi'].toString() : null,
    );
  }
}
