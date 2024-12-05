import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/models/lokasi_model.dart';
import 'package:greenpoint/service/lokasi_service.dart';

class LokasiController with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<LokasiModel> _lokasiList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<LokasiModel> get lokasiList => _lokasiList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLokasi(double startLat, double startLon) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _secureStorage.read(key: 'auth_token');
    try {
      // Memanggil service dengan parameter startLat dan startLon
      _lokasiList = await LokasiService.fetchLokasi(token, startLat, startLon);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
