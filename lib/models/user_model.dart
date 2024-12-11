import 'package:greenpoint/assets/constants/api_url.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? fotoProfil; // Bisa null
  final int poin;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.fotoProfil,
    this.poin = 0,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['foto_profil'] as String?;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = ApiUrl.baseImageUrl + imageUrl;
    }

    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      fotoProfil: imageUrl,
      poin: json['poin'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'foto_profil': fotoProfil, // Optional, can be null
      'poin': poin,
      'created_at': createdAt,
    };
  }
}
