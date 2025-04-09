import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:greenpoint/models/artikel_model.dart';

class ArtikelService {
  final url = ApiUrl.buildUrl(ApiUrl.artikel);

  // Fetch all articles
  Future<List<Artikel>> fetchAllArtikel(String? token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = json.decode(response.body);
      return data.map((artikelJson) => Artikel.fromJson(artikelJson)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<Artikel> fetchArtikelById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'));
    if (response.statusCode == 200) {
      return Artikel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load article');
    }
  }
}
