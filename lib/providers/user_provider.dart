import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Map<String, dynamic>? _user;
  String? _token;
  String userName = "";
  int poin = 0;

  Map<String, dynamic>? get user => _user;
  int get userPoints => _user?['poin'] ?? 0;

  Future<void> setUser(Map<String, dynamic> userData, String token) async {
    _user = userData;
    _token = token;

    await _saveToStorage('auth_token', token);
    await _saveToStorage('user_data', json.encode(userData));

    notifyListeners();
  }

  /// Save any data to secure storage
  Future<void> _saveToStorage(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      print('$key saved: $value');
    } catch (e) {
      print('Error saving $key: $e');
    }
  }

  /// Read token from secure storage
  Future<void> readToken() async {
    try {
      _token = await _secureStorage.read(key: 'auth_token');
      if (_token == null || _token!.isEmpty) {
        print('No authentication token found');
      } else {
        print('Token fetched: $_token');
      }
    } catch (e) {
      print('Error reading token: $e');
    }
  }

  /// Clear user data and token from secure storage
  Future<void> clearUser() async {
    _user = null;
    _token = null;

    await _deleteFromStorage('auth_token');
    await _deleteFromStorage('user_data');

    notifyListeners();
  }

  /// Delete specific data from secure storage
  Future<void> _deleteFromStorage(String key) async {
    try {
      await _secureStorage.delete(key: key);
      print('$key deleted');
    } catch (e) {
      print('Error deleting $key: $e');
    }
  }

  /// Fetch user data from secure storage
  Future<void> fetchUserData() async {
    try {
      // Membaca data pengguna dari Secure Storage
      final userDataString = await _secureStorage.read(key: 'user_data');

      if (userDataString != null && userDataString.isNotEmpty) {
        _user = json.decode(userDataString);
        // print("hello"+ _user.toString());
        // Mengatur userName dari data yang sudah didecode
        userName = _user?['name'] ?? 'Default Name';
        poin = _user?['poin'] ?? 0;
        print('User data fetched: $_user');
      } else {
        print('No user data found');
        _user = {}; // Initialize _user as an empty map if no data is found
        userName =
            'Default Name'; // Mengatur userName default jika data tidak ditemukan
      }

      // Memanggil notifyListeners agar UI diperbarui
      notifyListeners();
    } catch (e) {
      print('Error fetching user data: $e');
      userName = 'Default Name'; // Mengatur userName default jika terjadi error
    }
  }

  /// Check if the token is valid
  bool isTokenValid() => _token != null && _token!.isNotEmpty;

  /// Refresh token (currently a placeholder for future implementation)
  Future<bool> refreshToken() async {
    try {
      // Token refresh logic can be added here
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  /// Debug: Print all data in secure storage
  Future<void> debugSecureStorage() async {
    try {
      final allKeys = await _secureStorage.readAll();
      print('All Secure Storage Data: $allKeys');

      final token = await _secureStorage.read(key: 'auth_token');
      print('Fetched auth token: $token');
    } catch (e) {
      print('Error while reading secure storage: $e');
    }
  }
}
