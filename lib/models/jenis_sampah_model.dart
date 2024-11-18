import 'package:greenpoint/assets/constants/api_url.dart';

class JenisSampah {
  final String foto;
  final String judul;
  final double harga;

  // static const String baseImageUrl = 'http:10.0.2.2:8000/storage/';

  JenisSampah({
    required this.foto,
    required this.judul,
    required this.harga,
  });

  factory JenisSampah.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['foto'] as String;
    if (!imageUrl.startsWith('http')) {
      imageUrl = ApiUrl.baseImageUrl + imageUrl;
    }

    double harga = json['harga'] is int ? (json['harga'] as int).toDouble() : json['harga'] as double;

    return JenisSampah(
      foto: imageUrl,
      judul: json['judul'] as String,
      harga: harga,
    );
  }

  String get imageUrl {
    if (foto.startsWith('http')) {
      return foto;
    }
    return ApiUrl.baseImageUrl + foto;
  }
}
