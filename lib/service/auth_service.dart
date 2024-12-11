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
  Future<UserModel?> userData(String? token) async {
    final url = ApiUrl.buildUrl(ApiUrl.user);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Decoded JSON Data: $data');
        print('Data Type: ${data.runtimeType}');

        // Check if the data is a Map and has a 'data' or 'user' key
        if (data is Map) {
          final userData = data['data'] ?? data['user'] ?? data;
          print('User Data to Parse: $userData');

          return UserModel.fromJson(userData);
        }

        return UserModel.fromJson(data);
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
Future<UserModel?> updateUserData({
  required String? token,
  String? name,
  String? password,
  String? imagePath,
}) async {
  final url = ApiUrl.buildUrl(ApiUrl.updateUser);
  try {
    print('Sending update request with name: $name');
    
    var request = http.MultipartRequest('PUT', Uri.parse(url))
      ..headers.addAll({
        'Authorization': 'Bearer $token',
      });

    if (name != null && name.isNotEmpty) {
      request.fields['name'] = name;
      print('Name field added: $name');
    }

    var response = await request.send();
    
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('Full Response Body: $responseBody');
      
      final jsonResponse = jsonDecode(responseBody);
      print('Parsed Response: $jsonResponse');
      
      if (jsonResponse['success'] == true && jsonResponse.containsKey('user')) {
        print('Updated User Name: ${jsonResponse['user']['name']}');
        return UserModel.fromJson(jsonResponse['user']);
      }
    }

    throw Exception('Update failed');
  } catch (e) {
    print('Update error: $e');
    rethrow;
  }
}

}
