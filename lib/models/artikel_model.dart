import 'package:greenpoint/assets/constants/api_url.dart';

class Artikel {
  final int id;
  final String judul;
  final String isi;
  final DateTime tanggal;
  final String foto;

  Artikel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.foto,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {

    String imageUrl = json['foto'] as String;
    if (!imageUrl.startsWith('http')) {
      imageUrl = ApiUrl.baseImageUrl + imageUrl;
    }
    return Artikel(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      tanggal: DateTime.parse(json['tanggal']),
      foto: imageUrl,
    );
  }
}

