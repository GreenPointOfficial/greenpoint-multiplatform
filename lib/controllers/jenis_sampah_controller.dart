import 'dart:async';
import 'package:flutter/material.dart';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:greenpoint/service/jenis_sampah_service.dart';

class JenisSampahController extends ChangeNotifier {
  
  List<JenisSampah> _jenisSampahList = [];
  bool _isLoading = false;

  JenisSampah? _jenisSampahById;

  final StreamController<List<JenisSampah>> _jenisSampahStreamController = StreamController<List<JenisSampah>>.broadcast();
  final StreamController<JenisSampah?> _jenisSampahByIdStreamController = StreamController<JenisSampah?>.broadcast();

  List<JenisSampah> get jenisSampahList => _jenisSampahList;
  bool get isLoading => _isLoading;
  JenisSampah? get jenisSampahById => _jenisSampahById;

  final JenisSampahService _apiService = JenisSampahService();

  Future<void> fetchJenisSampah() async {
    _isLoading = true;
    notifyListeners();

    try {
      _jenisSampahList = await _apiService.fetchJenisSampah();
      _jenisSampahStreamController.sink.add(_jenisSampahList);  
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchJenisSampahById(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _jenisSampahById = await _apiService.fetchJenisSampahById(id);
      _jenisSampahByIdStreamController.sink.add(_jenisSampahById);
    } catch (e) {
      print('Error fetching data for ID $id: $e');
      _jenisSampahByIdStreamController.sink.add(null);  
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<JenisSampah>> get jenisSampahStream => _jenisSampahStreamController.stream;

  Stream<JenisSampah?> get jenisSampahByIdStream => _jenisSampahByIdStreamController.stream;

  void dispose() {
    _jenisSampahStreamController.close();
    _jenisSampahByIdStreamController.close();
    super.dispose();
  }
}
