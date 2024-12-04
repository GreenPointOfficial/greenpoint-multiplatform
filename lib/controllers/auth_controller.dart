import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {
  final AuthService _authService = AuthService();
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

  // Handle Google login
  Future<Map<String, dynamic>> handleGoogleLogin() async {
    try {
      String token = await _authService.signInWithGoogle();

      if (token.isNotEmpty) {
        return {
          'success': true,
          'message': 'Google login successful',
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': 'Google login failed: Empty token',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Google login failed: $e',
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

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      String? token = await _secureStorage.read(key: 'auth_token');
      print('Fetched auth token: $token');

      if (token == null) {
        print('No authentication token found');
        return null;
      }

      final url = ApiUrl.buildUrl(ApiUrl.user);
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['success'] == true) {
          return responseBody['user'];
        } else {
          print('Failed to fetch user profile');
          return null;
        }
      } else if (response.statusCode == 401) {
        // Token tidak valid, mungkin perlu logout
        await _secureStorage.delete(key: 'auth_token');
        print('Token expired or invalid');
        return null;
      } else {
        print('Error fetching user profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception in fetchUserProfile: $e');
      return null;
    }
  }
}
