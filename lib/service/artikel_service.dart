import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:greenpoint/models/artikel_model.dart';

class ArtikelService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1/artikel';

  // Fetch all articles
  Future<List<Artikel>> fetchAllArtikel() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((artikelJson) => Artikel.fromJson(artikelJson)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  // Fetch a single article by ID
  Future<Artikel> fetchArtikelById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Artikel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load article');
    }
  }

  // Create a new article
  Future<Artikel> createArtikel(Artikel artikel) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(artikel.toJson()),
    );

    if (response.statusCode == 201) {
      return Artikel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create article');
    }
  }

  // Update an article by ID
  Future<Artikel> updateArtikel(int id, Artikel artikel) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(artikel.toJson()),
    );

    if (response.statusCode == 200) {
      return Artikel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update article');
    }
  }

  // Delete an article by ID
  Future<void> deleteArtikel(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete article');
    }
  }
}
