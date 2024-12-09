import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

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
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      print(
          'Login response from service: ${response.body}'); // Log respons API untuk debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

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

  // Future<Map<String, dynamic>> fetchProtectedResource(String endpoint) async {
  //   final token = await getToken();
  //   if (token == null) throw Exception('User is not authenticated.');

  //   final url = ApiUrl.buildUrl(endpoint);
  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed to fetch resource: ${response.body}');
  //   }
  // }

  Future<UserModel> userData(String? token) async {
    final url = ApiUrl.buildUrl(ApiUrl.user);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load data user ');
    }
  }
  }

  // Future<UserModel> updateUserData({
  //   required String? token,
  //   String? name,
  //   String? password,
  //   String? imagePath,
  // }) async {
  //   final url = ApiUrl.buildUrl(ApiUrl.updateUser);
  //   try {
  //     // Validate token
  //     if (token == null || token.isEmpty) {
  //       throw Exception('Token tidak valid atau kosong.');
  //     }

  //     // Create multipart request
  //     var request = http.MultipartRequest('PUT', Uri.parse(url))
  //       ..headers.addAll({
  //         'Authorization': 'Bearer $token',
  //       });

  //     // Add name if provided
  //     if (name != null && name.isNotEmpty) {
  //       request.fields['name'] = name;
  //       print('Sending name: $name'); // Debug print
  //     }

  //     // Add password if provided
  //     if (password != null && password.isNotEmpty) {
  //       request.fields['password'] = password;
  //     }

  //     // Add image if provided
  //     if (imagePath != null && imagePath.isNotEmpty) {
  //       try {
  //         request.files.add(await http.MultipartFile.fromPath(
  //           'foto_profil',
  //           imagePath,
  //         ));
  //       } catch (e) {
  //         throw Exception('Gagal menambahkan file gambar: $e');
  //       }
  //     }

  //     // Log request details
  //     print('Request URL: $url');
  //     print('Headers: ${request.headers}');
  //     print('Fields: ${request.fields}');
  //     print('ImagePath: $imagePath');

  //     // Send request
  //     var response = await request.send();

  //     // Process response
  //     if (response.statusCode == 200) {
  //       final responseBody = await response.stream.bytesToString();
  //       print('Response Body: $responseBody');

  //       final jsonResponse = jsonDecode(responseBody);

  //       if (jsonResponse['success'] == true &&
  //           jsonResponse.containsKey('user')) {
  //         // Update secure storage with latest data
  //         await _secureStorage.write(
  //           key: 'user_data',
  //           value: json.encode({
  //             'name': jsonResponse['user']['name'],
  //             'email': jsonResponse['user']['email'],
  //             'poin': jsonResponse['user']['poin'] ?? 'N/A',
  //             'foto_profile':
  //                 jsonResponse['user']['foto_profil'] ?? 'default_image',
  //             'created_at': jsonResponse['user']['created_at'],
  //           }),
  //         );

  //         // Return updated user model
  //         return UserModel.fromJson(jsonResponse['user']);
  //       } else {
  //         throw Exception(
  //             jsonResponse['message'] ?? 'Gagal memperbarui profil.');
  //       }
  //     } else {
  //       throw Exception(
  //           'Gagal memperbarui profil. Status Code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Terjadi kesalahan: $e');
  //     throw Exception('Terjadi kesalahan saat memperbarui profil: $e');
  //   }
  // }

