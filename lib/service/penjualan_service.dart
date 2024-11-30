import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/penjualan_model.dart';
import 'package:http/http.dart' as http;

class PenjualanService {
  Future<List<PenjualanModel>> fetchPenjualan(String? token) async {
    final url = ApiUrl.buildUrl(ApiUrl.penjualanByUser);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((json) => PenjualanModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load penjualan data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
