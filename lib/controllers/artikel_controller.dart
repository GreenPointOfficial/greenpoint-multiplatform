import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/models/artikel_model.dart';
import 'package:greenpoint/service/artikel_service.dart';

class ArtikelController extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<Artikel> _artikelList = [];
  Artikel? _artikelById;
  bool _isLoading = false;

  // Stream Controllers
  final StreamController<List<Artikel>> _artikelStreamController =
      StreamController<List<Artikel>>.broadcast();
  final StreamController<Artikel?> _artikelByIdStreamController =
      StreamController<Artikel?>.broadcast();

  // Service
  final ArtikelService _artikelService = ArtikelService();

  // Getters
  List<Artikel> get artikelList => _artikelList;
  Artikel? get artikelById => _artikelById;
  bool get isLoading => _isLoading;

  // Streams
  Stream<List<Artikel>> get artikelStream => _artikelStreamController.stream;
  Stream<Artikel?> get artikelByIdStream => _artikelByIdStreamController.stream;

  // Fetch all articles
  Future<void> fetchAllArtikel() async {
    final token = await _secureStorage.read(key: 'auth_token');

    _isLoading = true;
    notifyListeners();

    try {
      _artikelList = await _artikelService.fetchAllArtikel(token);
      _artikelStreamController.sink.add(_artikelList);
    } catch (e) {
      _artikelStreamController.sink.addError('Error fetching articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch an article by ID
  Future<void> fetchArtikelById(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _artikelById = await _artikelService.fetchArtikelById(id);
      _artikelByIdStreamController.sink.add(_artikelById);
    } catch (e) {
      print('Error fetching article with ID $id: $e');
      _artikelByIdStreamController.sink.add(null);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _artikelStreamController.close();
    _artikelByIdStreamController.close();
    super.dispose();
  }
}
