import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/models/penjualan_model.dart';
import 'package:greenpoint/service/penjualan_service.dart';

class PenjualanController with ChangeNotifier {
    final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final PenjualanService _penjualanService = PenjualanService();

  List<PenjualanModel> _penjualanList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PenjualanModel> get penjualanList => _penjualanList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch penjualan data
  Future<void> fetchPenjualan() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
        final token = await _secureStorage.read(key: 'auth_token');


    try {
      final data = await _penjualanService.fetchPenjualan(token);
      _penjualanList = data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
