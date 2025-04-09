import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/models/penjualan_model.dart';
import 'package:greenpoint/models/top_penjualan_model.dart';
import 'package:greenpoint/service/penjualan_service.dart';

class PenjualanController extends ChangeNotifier {
  final PenjualanService _penjualanService = PenjualanService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Variables to hold fetched data
  List<TopPenjualan> topPenjualanList = [];
  List<RiwayatPenjualan> riwayatPenjualanList = [];
  int? _userPercentage;
  int? get userPercentage => _userPercentage;
  int? _bonus;
  String? _claimMessage;
  int? get bonus => _bonus;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? get claimMessage => _claimMessage;

  // Method to fetch top penjualan
  Future<void> getTopPenjualan() async {
    _isLoading = true;
    _errorMessage = null; // Reset the error message
    notifyListeners();
    // print("hello from controller");

    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      _errorMessage = "No authentication token found. Please log in.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      topPenjualanList = await _penjualanService.fetchTopPenjualan(token);
      print("hello from controller");
    } catch (e) {
      _errorMessage = 'Error fetching top penjualan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to fetch riwayat penjualan
  Future<void> getRiwayatPenjualan() async {
    _isLoading = true;
    _errorMessage = null; // Reset the error message
    notifyListeners();

    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      _errorMessage = "No authentication token found. Please log in.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      riwayatPenjualanList =
          await _penjualanService.fetchRiwayatPenjualan(token);
    } catch (e) {
      _errorMessage = 'Error fetching riwayat penjualan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserPercentage() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      _errorMessage = "No authentication token found. Please log in.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final data = await _penjualanService.getUserPercentage(token);
      _userPercentage = data['data']['persentase'];
      print("User Percentage: $_userPercentage");
    } catch (e) {
      _errorMessage = 'Error fetching user percentage: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> autoClaimBonus(int weight, int points) async {
    print("ini berat: $weight");
    _isLoading = true;
    _errorMessage = null; // Reset the error message
    notifyListeners();

    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      _errorMessage = "No authentication token found. Please log in.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final data = await _penjualanService.claimBonus(token, weight, points);
      _bonus = data['data']['bonus'];
      _claimMessage = data['message']; // Save the success message
      print("User Bonus+: $_bonus"); // Check the value received
    } catch (e) {
      _claimMessage = null; // Reset the claim message
      _errorMessage = e.toString();
      print("Error claiming bonus: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Ensure the UI is notified about the changes
    }
  }
}
