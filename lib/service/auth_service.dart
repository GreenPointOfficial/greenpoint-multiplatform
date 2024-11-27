import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
      // If registration is successful, return the success response
      return {'success': true, 'message': 'Registration successful'};
    } else {
      throw Exception('Gagal register: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = ApiUrl.buildUrl(ApiUrl.login);
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Login successful'};
    } else {
      throw Exception('Gagal register: ${response.body}');
    }
  }
Future<String> signInWithGoogle() async {
    try {
      // Start the Google Sign-In process
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in process
        throw Exception("Google sign-in was canceled.");
      }

      // Obtain authentication details
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Return the Google ID token
      return googleAuth.idToken ?? '';
    } catch (e) {
      // Catch and print the error message
      print("Google Sign-In error: $e");
      throw Exception("Google Sign-In failed: $e");
    }
  }
}
