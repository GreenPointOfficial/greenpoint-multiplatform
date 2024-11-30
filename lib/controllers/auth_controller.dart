import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> registerUser(String name, String email, String password) async {
    try {
      if (password.length < 8) {
        throw Exception('Password must be at least 8 characters long');
      }

      final response = await _authService.register(name, email, password);

      if (response['success']) {
        print('User successfully registered: ${response['message']}');
      } else {
        print('Registration failed: ${response['message']}');
      }
    } catch (e) {
      print('Error in AuthController: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await _authService.login(email, password);

      print(response);
      // Periksa apakah response null atau tidak sesuai format
      if (response.containsKey('token')) {
        final token = response['token'];

        // Jika token ada, kembalikan sebagai sukses
        return {
          'success': true,
          'message': 'Login successful',
          'user_data': response['user_data'],
          'token': token,
        };
      } else {
        throw Exception('Token is missing or response is invalid');
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Login failed: $e',
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
          'token': token, // Add token to the response
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
