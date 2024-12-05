import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/lokasi_model.dart';
import 'package:http/http.dart' as http;

class LokasiService {
  static Future<List<LokasiModel>> fetchLokasi(String? token) async {
    final url = "${ApiUrl.buildUrl(ApiUrl.lokasi)}";
 final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => LokasiModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load lokasi');
    }
  }
}
