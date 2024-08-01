class Kurir {
  static Kurir? _instance;
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama_lengkap': namaLengkap,
    'nohp': nohp,
    'username': username,
    'password': password,
    'region': region,
    'no_polisi': noPolisi,
  };

  static Kurir? getInstance() {
    return _instance;
  }

  static void setInstance(Kurir kurir) {
    _instance = kurir;
  }

  static void resetInstance() {
    _instance = null;
  }

}
