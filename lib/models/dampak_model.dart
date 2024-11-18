import 'package:greenpoint/assets/constants/api_url.dart';

class DampakModel {
  final int id;
  final int idJenisSampah;
  final String foto;
  final String isi;

  DampakModel({
    required this.id,
    required this.idJenisSampah,
    required this.foto,
    required this.isi,
  });

  factory DampakModel.fromJson(Map<String, dynamic> json) {

     String imageUrl = json['foto'] as String;
    if (!imageUrl.startsWith('http')) {
      imageUrl = ApiUrl.baseImageUrl + imageUrl;
    }
    return DampakModel(
      id: json['id'],
      idJenisSampah: json['id_jenis_sampah'],
      foto: imageUrl,
      isi: json['isi'],
    );
  }
}