class JenisSampah {
  final String foto;
  final String judul;
  final double harga;

  static const String baseImageUrl = 'https://1f74-182-1-38-228.ngrok-free.app/storage/';

  JenisSampah({
    required this.foto,
    required this.judul,
    required this.harga,
  });

  factory JenisSampah.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['foto'] as String;
    if (!imageUrl.startsWith('http')) {
      imageUrl = baseImageUrl + imageUrl;
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
    return baseImageUrl + foto;
  }
}
