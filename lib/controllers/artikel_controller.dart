import 'package:flutter/material.dart';
import 'package:greenpoint/models/artikel_model.dart';
import 'package:greenpoint/service/artikel_service.dart';

class ArtikelController extends ChangeNotifier {
  
  final ArtikelService _artikelService = ArtikelService();

  List<Artikel> _artikels = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Artikel> get artikels => _artikels;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch all articles
  Future<void> fetchAllArtikel() async {
    _isLoading = true;
    notifyListeners();

    try {
      _artikels = await _artikelService.fetchAllArtikel();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch a single article by ID
  Future<void> fetchArtikelById(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final artikel = await _artikelService.fetchArtikelById(id);
      _artikels = [artikel]; 
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
