import 'dart:convert';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:http/http.dart' as http;

class JenisSampahService {
  final String baseUrl = "https://1f74-182-1-38-228.ngrok-free.app/api/v1";

  Future<List<JenisSampah>> fetchJenisSampah() async {
    final response = await http.get(
      Uri.parse('$baseUrl/jenis-sampah'),
      headers: {
        'Connection': 'keep-alive', 
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => JenisSampah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
