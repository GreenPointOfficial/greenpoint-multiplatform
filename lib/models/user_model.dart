import 'package:greenpoint/assets/constants/api_url.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  String? fotoProfil; 
  int poin;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.fotoProfil, 
    this.poin = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['foto_profil'] as String;
    if (!imageUrl.startsWith('http')) {
      imageUrl = ApiUrl.baseImageUrl + imageUrl;
    }


    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      fotoProfil: imageUrl,
      poin: json['poin']
    );
  }
  
}
