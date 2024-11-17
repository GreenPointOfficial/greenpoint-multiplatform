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
      _artikels = [artikel];  // Update with a single article
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create a new article
  Future<void> createArtikel(Artikel artikel) async {
    try {
      final newArtikel = await _artikelService.createArtikel(artikel);
      _artikels.add(newArtikel);  // Add the new article to the list
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    notifyListeners();
  }

  // Update an existing article
  Future<void> updateArtikel(int id, Artikel artikel) async {
    try {
      final updatedArtikel = await _artikelService.updateArtikel(id, artikel);
      final index = _artikels.indexWhere((a) => a.id == id);
      if (index != -1) {
        _artikels[index] = updatedArtikel;  // Update the article in the list
      }
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    notifyListeners();
  }

  // Delete an article
  Future<void> deleteArtikel(int id) async {
    try {
      await _artikelService.deleteArtikel(id);
      _artikels.removeWhere((a) => a.id == id);  // Remove the deleted article
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    notifyListeners();
  }
}
