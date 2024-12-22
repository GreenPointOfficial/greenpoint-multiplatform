import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greenpoint/models/user_model.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:greenpoint/views/widget/navbar_widget.dart';

class AuthController {
  final AuthService _authService = AuthService();
  UserModel? _userData;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      // Validasi input awal
      if (name.isEmpty) {
        throw Exception('Nama tidak boleh kosong');
      }
      if (email.isEmpty) {
        throw Exception('Email tidak boleh kosong');
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw Exception('Format email tidak valid');
      }
      if (password.isEmpty) {
        throw Exception('Password tidak boleh kosong');
      }
      if (password.length < 8) {
        throw Exception('Password harus memiliki minimal 8 karakter');
      }

      // Panggil API untuk registrasi
      final response = await _authService.register(name, email, password);

      if (response['success']) {
        // Jika registrasi berhasil
        print('User successfully registered: ${response['message']}');
        return true;
      } else {
        // Jika ada kesalahan dalam proses registrasi
        final errorMessage = response['message'] ?? 'Registrasi gagal';
        if (response['error_code'] == 'EMAIL_ALREADY_EXISTS') {
          throw Exception('Email sudah digunakan. Silakan gunakan email lain.');
        } else {
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      // Log error untuk debugging
      print('Error in AuthController: $e');
      // Lempar error ke pemanggil fungsi agar UI bisa menangani
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      // Panggil service login
      final response = await _authService.login(email, password);

      if (response['success']) {
        return {
          'success': true,
          'message': response['message'],
          'user_data': response['user_data'],
          'token': response['token'],
        };
      } else {
        return {
          'success': false,
          'message': response['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat login: $e',
      };
    }
  }

  Future<Map<String, dynamic>> handleGoogleLogin() async {
    try {
      UserModel user = await _authService.signInWithGoogle();

      return {
        'success': true,
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _authService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logoutUser() async {
    try {
      await _authService.clearToken();
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Future<Map<String, dynamic>?> fetchUserProfile() async {
  //   try {
  //     String? token = await _secureStorage.read(key: 'auth_token');
  //     print('Fetched auth token: $token');

  //     if (token == null) {
  //       print('No authentication token found');
  //       return null;
  //     }

  //     final url = ApiUrl.buildUrl(ApiUrl.user);
  //     final response = await http.get(Uri.parse(url), headers: {
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json'
  //     });

  //     if (response.statusCode == 200) {
  //       final responseBody = json.decode(response.body);

  //       if (responseBody['success'] == true) {
  //         return responseBody['user'];
  //       } else {
  //         print('Failed to fetch user profile');
  //         return null;
  //       }
  //     } else if (response.statusCode == 401) {
  //       // Token tidak valid, mungkin perlu logout
  //       await _secureStorage.delete(key: 'auth_token');
  //       print('Token expired or invalid');
  //       return null;
  //     } else {
  //       print('Error fetching user profile: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Exception in fetchUserProfile: $e');
  //     return null;
  //   }
  // }

  UserModel? get userData => _userData;

  /// Mengambil data pengguna dan menyimpannya ke dalam _userData
  Future<void> fetchUserData() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        print("Token tidak ditemukan atau kosong.");
        return;
      }

      // Memanggil data user
      final userData = await _authService.userData(token);

      if (userData == null) {
        print("Data user kosong.");
        return;
      }

      _userData = userData;
      print("Data user berhasil diambil: $_userData");
    } catch (e) {
      print("Error saat mengambil data user: $e");
    }
  }

  Future<void> updateUserProfile(
      String? name, String? password, String? imagePath) async {
    String? token = await _secureStorage.read(key: 'auth_token');
    print('Token: $token');

    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(
        msg: "Token tidak ditemukan, silakan login ulang.",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    try {
      var response = await _authService.updateUserData(
        token: token,
        name: name,
        password: password,
        imagePath: imagePath,
      );

      if (response != null) {
        print('Response from backend: ${response.toString()}');
        Fluttertoast.showToast(
          msg: "Profil berhasil diperbarui",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Pembaruan profil gagal",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: "Terjadi kesalahan: $e",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
}
