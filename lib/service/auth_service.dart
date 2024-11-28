import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Menyimpan token ke secure storage
  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Mengambil token dari secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  // Menghapus token saat logout
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Registrasi
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final url = ApiUrl.buildUrl(ApiUrl.register);
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'Registration successful'};
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = ApiUrl.buildUrl(ApiUrl.login);

    try {
      final response = await http.post(
        Uri.parse(url), // Ganti dengan URL API login Anda
        body: {
          'email': email,
          'password': password,
        },
      );

      print(
          'Login response from service: ${response.body}'); // Log respons API untuk debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Cek apakah token ada dalam respons
        if (data.containsKey('token') && data['token'] != null) {
          return {
            'success': true,
            'message': 'Login successful',
            'token': data['token'], // Ambil token dari token
            'user_data': data['user_data']
          };
        } else {
          throw Exception('Token is missing');
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Login dengan Google
  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Google sign-in was canceled.");
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Kirim Google ID token ke API untuk login
      final url = ApiUrl.buildUrl(ApiUrl.loginGoogle);
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_token': googleAuth.idToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        await _saveToken(token);
        return token;
      } else {
        throw Exception('Google login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception("Google Sign-In failed: $e");
    }
  }

  // Mendapatkan resource yang dilindungi menggunakan token
  Future<Map<String, dynamic>> fetchProtectedResource(String endpoint) async {
    final token = await getToken();
    if (token == null) throw Exception('User is not authenticated.');

    final url = ApiUrl.buildUrl(endpoint);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Menambahkan token ke header
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch resource: ${response.body}');
    }
  }
}
