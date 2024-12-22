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
            'token': data['token'], 
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

  Future<UserModel> signInWithGoogle() async {
  final url = ApiUrl.buildUrl(ApiUrl.loginGoogle);

  try {
    // Start the Google Sign-In process
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Sign in was cancelled by the user.');
    }

    // Authenticate user and get token from Google
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Unable to retrieve ID token from Google.');
    }

    // Send POST request to backend Laravel for verification
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_token': idToken, 
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Check if token exists
      if (data.containsKey('token') && data['token'] != null) {
        // Save the token securely, if needed
        await _saveToken(data['token']);

        // Save user data securely
        if (data.containsKey('user')) {
          final userData = data['user'];
          
          // Serialize the user data to JSON and save it securely
          await _secureStorage.write(key: 'user_data', value: json.encode(userData));

          // Return the UserModel instance
          return UserModel.fromJson(userData); // Return UserModel instance
        } else {
          throw Exception('User data is missing from server response.');
        }
      } else {
        throw Exception('Token is missing from server response.');
      }
    } else {
      throw Exception('Failed to authenticate with the server. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during Google sign-in: $e');
    throw Exception('Google Sign-In failed. Reason: $e');
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
      print('Update Request:');
      print('Token: $token');
      print('Name: $name');
      print('Image Path: $imagePath');

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Membuat payload JSON
      var body = jsonEncode({
        'name': name,
        // 'password': password,
      });

      if (imagePath != null && imagePath.isNotEmpty) {
        body = jsonEncode({
          'name': name,
          // 'password': password,
          'foto_profil':
              ApiUrl.baseUrl + imagePath, // Menambahkan path gambar di JSON
        });
      }

      var response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          jsonResponse['success'] == true &&
          jsonResponse.containsKey('user')) {
        return UserModel.fromJson(jsonResponse['user']);
      }

      throw Exception('Update failed: ${jsonResponse['message']}');
    } catch (e) {
      print('Update error: $e');
      rethrow;
    }
  }
}
