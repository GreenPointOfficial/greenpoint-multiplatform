import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:greenpoint/models/artikel_model.dart';

class ArtikelService {
  final String baseUrl = ApiUrl.artikel;

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

  
  
}
