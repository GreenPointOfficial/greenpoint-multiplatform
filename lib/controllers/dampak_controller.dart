import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/models/dampak_model.dart';
import 'package:greenpoint/service/dampak_service.dart';

class DampakController extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<DampakModel> _dampakByIdJenisSampah = [];
  bool _isLoading = false;

  final StreamController<List<DampakModel>> _jenisSampahStreamController =
      StreamController<List<DampakModel>>.broadcast();
  final StreamController<bool> _loadingStreamController =
      StreamController<bool>.broadcast();

  List<DampakModel> get dampakByIdJenisSampah => _dampakByIdJenisSampah;
  bool get isLoading => _isLoading;
  Stream<List<DampakModel>> get dampakStream =>
      _jenisSampahStreamController.stream;
  Stream<bool> get loadingStream => _loadingStreamController.stream;

  final DampakService _apiService = DampakService();

  Future<void> fetchDampakByIdJenisSampah(int idJenisSampah) async {
    final token = await _secureStorage.read(key: 'auth_token');

    _isLoading = true;
    notifyListeners();

    _dampakByIdJenisSampah = [];
    _jenisSampahStreamController.sink.add(_dampakByIdJenisSampah);

    try {
      _dampakByIdJenisSampah =
          await _apiService.fetchDampakByIdJenisSampah(idJenisSampah, token);
      _jenisSampahStreamController.sink.add(_dampakByIdJenisSampah);
    } catch (e) {
      _dampakByIdJenisSampah = [];
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
