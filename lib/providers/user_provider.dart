import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Map<String, dynamic>? _user;
  String? _token;
  String userName = "";
  String email = "";
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

  Future<void> logout() async {
    await clearUser(); // Clear the user data and token
    // Optionally, redirect to the login page or perform any additional logout actions.
  }

  Future<void> _saveToStorage(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      // print('$key saved: $value');
    } catch (e) {
      // print('Error saving $key: $e');
    }
  }

  Future<void> readToken() async {
    try {
      _token = await _secureStorage.read(key: 'auth_token');
      if (_token == null || _token!.isEmpty) {
        // print('No authentication token found');
      } else {
        // print('Token fetched: $_token');
      }
    } catch (e) {
      // print('Error reading token: $e');
    }
  }

  Future<void> clearUser() async {
    _user = null;
    _token = null;

    await _deleteFromStorage('auth_token');
    await _deleteFromStorage('user_data');

    notifyListeners();
  }

  Future<void> _deleteFromStorage(String key) async {
    try {
      await _secureStorage.delete(key: key);
      // print('$key deleted');
    } catch (e) {
      // print('Error deleting $key: $e');
    }
  }

  Future<void> fetchUserData() async {
    try {
      final userDataString = await _secureStorage.read(key: 'user_data');

      if (userDataString != null && userDataString.isNotEmpty) {
        _user = json.decode(userDataString);
        userName = _user?['name'] ?? '';
        email = _user?['email'] ?? '';
        poin = _user?['poin'] ?? 0;
        // print('User data fetched: $_user');
      } else {
        // print('No user data found');
        _user = {};
        userName = '';
        email = '';
      }

      notifyListeners();
    } catch (e) {
      // print('Error fetching user data: $e');
      userName = '';
      email = '';
    }
  }

  bool isTokenValid() => _token != null && _token!.isNotEmpty;

  Future<bool> refreshToken() async {
    try {
      return false;
    } catch (e) {
      // print('Token refresh error: $e');
      return false;
    }
  }

  Future<void> autoRefreshUserData(Map<String, dynamic> updatedUserData) async {
    try {
      _user = {
        ...?_user,
        ...updatedUserData,
      };

      await _saveToStorage('user_data', json.encode(_user));

      await fetchUserData();

      // print('User data updated and UI refreshed: $_user');
    } catch (e) {
      // print('Error during auto-refresh of user data: $e');
    }
  }

  // Future<void> debugSecureStorage() async {
  //   try {
  //     final allKeys = await _secureStorage.readAll();
  //     // print('All Secure Storage Data: $allKeys');

  //     final token = await _secureStorage.read(key: 'auth_token');
  //     print('Fetched auth token: $token');
  //   } catch (e) {
  //     print('Error while reading secure storage: $e');
  //   }
  // }
}
