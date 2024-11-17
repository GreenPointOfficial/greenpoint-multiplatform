import 'package:flutter/material.dart';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:greenpoint/service/jenis_sampah_service.dart';


class JenisSampahController extends ChangeNotifier {
  List<JenisSampah> _jenisSampahList = []; // Tambahkan tipe data spesifik
  bool _isLoading = false;

  List<JenisSampah> get jenisSampahList => _jenisSampahList;
  bool get isLoading => _isLoading;

  final JenisSampahService _apiService = JenisSampahService();

  Future<void> fetchJenisSampah() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _jenisSampahList = await _apiService.fetchJenisSampah(); // Hapus tanda *
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}