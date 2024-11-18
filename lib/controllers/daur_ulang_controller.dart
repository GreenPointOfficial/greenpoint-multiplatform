import 'dart:async';
import 'package:flutter/material.dart';
import 'package:greenpoint/models/daur_ulang_model.dart';
import 'package:greenpoint/service/daur_ulang_service.dart';

class DaurUlangController extends ChangeNotifier {
  List<DaurUlangModel> _daurUlangByIdJenisSampah = [];
  bool _isLoading = false;

  final StreamController<List<DaurUlangModel>> _jenisSampahStreamController =
      StreamController<List<DaurUlangModel>>.broadcast();
  final StreamController<bool> _loadingStreamController =
      StreamController<bool>.broadcast();

  List<DaurUlangModel> get daurUlangByIdJenisSampah =>
      _daurUlangByIdJenisSampah;
  bool get isLoading => _isLoading;
  Stream<List<DaurUlangModel>> get dampakStream =>
      _jenisSampahStreamController.stream;
  Stream<bool> get loadingStream => _loadingStreamController.stream;

  final DaurUlangService _apiService = DaurUlangService();

  Future<void> fetchDaurUlangByIdJenisSampah(int idJenisSampah) async {
    _isLoading = true;
    notifyListeners();

    _daurUlangByIdJenisSampah = [];
    _jenisSampahStreamController.sink.add(_daurUlangByIdJenisSampah);

    try {
      _daurUlangByIdJenisSampah =
          await _apiService.fetchDaurUlangByIdJenisSampah(idJenisSampah);
      _jenisSampahStreamController.sink.add(_daurUlangByIdJenisSampah);
    } catch (e) {
      _daurUlangByIdJenisSampah = [];
      _jenisSampahStreamController.sink.addError('Failed to load data');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _jenisSampahStreamController.close();
    _loadingStreamController.close();
    super.dispose();
  }
}
