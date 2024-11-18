import 'package:greenpoint/assets/constants/api_url.dart';

class DaurUlangModel {
  final int id;
  final int idJenisSampah;
  final String foto;
  final String judul;

  DaurUlangModel({
    required this.id,
    required this.idJenisSampah,
    required this.foto,
    required this.judul,
  });

  factory DaurUlangModel.fromJson(Map<String, dynamic> json) {

     String imageUrl = json['foto'] as String;
    if (!imageUrl.startsWith('http')) {
      imageUrl = ApiUrl.baseImageUrl + imageUrl;
    }
    return DaurUlangModel(
      id: json['id'],
      idJenisSampah: json['id_jenis_sampah'],
      foto: imageUrl,
      judul: json['judul'],
    );
  }
}