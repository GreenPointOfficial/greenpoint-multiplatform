import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  Map<String, dynamic>? _user;
  String? _token;

  // Getter for user data
  Map<String, dynamic>? get user => _user;

  // Getter for token
  String? get token => _token;

  // Check if user is authenticated
  bool get isAuthenticated => _token != null;

  // Constructor to load user data on initialization
  UserProvider() {
    _loadUserFromStorage();
  }

  // Save user data and token
  Future<void> setUser(Map<String, dynamic> userData) async {
    _user = userData;
    _token = userData['token'];

    // Save token to secure storage
    await _secureStorage.write(
      key: 'auth_token', 
      value: _token
    );

    // Save full user data to secure storage
    await _secureStorage.write(
      key: 'user_data', 
      value: json.encode(userData)
    );

    notifyListeners();
  }

  // Load user data from secure storage
  Future<void> _loadUserFromStorage() async {
    try {
      // Retrieve token
      _token = await _secureStorage.read(key: 'auth_token');

      // Retrieve user data
      String? userDataString = await _secureStorage.read(key: 'user_data');
      
      if (userDataString != null) {
        _user = json.decode(userDataString);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }



  // Clear user data and token
  Future<void> clearUser() async {
    _user = null;
    _token = null;

    // Remove stored data
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');

    notifyListeners();
  }

  // Getters for specific user information
  String get userName {
    return _user?['name'] ?? 'Guest';
  }

  int get point {
    return _user?['poin'] ?? 0;
  }

  // Method to check token validity (optional)
  bool isTokenValid() {
    // Implement your token validation logic here
    // For example, check expiration, decode JWT, etc.
    return _token != null;
  }
}