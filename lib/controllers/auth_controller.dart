import 'package:greenpoint/service/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // Register user
  Future<void> registerUser(String name, String email, String password) async {
    try {
      // Validasi password (minimal 8 karakter)
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
      if (response != null && response.containsKey('token')) {
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

  // Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _authService.getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout user
  Future<void> logoutUser() async {
    try {
      await _authService.clearToken();
      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
