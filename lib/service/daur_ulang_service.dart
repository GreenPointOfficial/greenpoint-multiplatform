import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/daur_ulang_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaurUlangService {
  Future<List<DaurUlangModel>> fetchDaurUlangByIdJenisSampah(
      int idJenisSampah) async {
    final url = "${ApiUrl.buildUrl(ApiUrl.daurUlang)}/$idJenisSampah";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => DaurUlangModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('Data not found for ID $idJenisSampah');
    } else {
      throw Exception('Failed to load data for ID $idJenisSampah');
    }
  }
}
