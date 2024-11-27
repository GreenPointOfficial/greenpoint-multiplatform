import 'package:greenpoint/service/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  // AuthService googleAuthService = AuthService();

  Future<void> registerUser(String name, String email, String password) async {
    try {
      final response = await _authService.register(name, email, password);

      if (password.length < 8) {
        throw Exception('Password must be at least 8 characters long');
      }

      if (response['success']) {
        print('User successfully registered: ${response['message']}');
      } else {
        print('Registration failed: ${response['message']}');
      }
    } catch (e) {
      print('Error in AuthController: $e');
    }
  }

  // Regular login (email/password)
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      return response;
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan, silakan coba lagi.'};
    }
  }

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


}
