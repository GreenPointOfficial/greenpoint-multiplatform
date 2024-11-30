import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:http/http.dart' as http;

class JenisSampahService {
  

  Future<List<JenisSampah>> fetchJenisSampah(String? token) async {
    final url = ApiUrl.buildUrl(ApiUrl.jenisSampah);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',  
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => JenisSampah.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<JenisSampah> fetchJenisSampahById(int id, String? token) async {
    final url = "${ApiUrl.buildUrl(ApiUrl.jenisSampah)}/$id";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',  
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return JenisSampah.fromJson(data);
    } else {
      throw Exception('Failed to load data for ID $id');
    }
  }
}
