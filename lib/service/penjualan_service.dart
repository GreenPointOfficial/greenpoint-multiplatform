import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/penjualan_model.dart';
import 'package:greenpoint/models/top_penjualan_model.dart';
import 'package:http/http.dart' as http;

class PenjualanService {
  Future<List<TopPenjualan>> fetchTopPenjualan(String? token) async {
    final url = ApiUrl.buildUrl(ApiUrl.penjualanTop);
    print("Requesting API: ${url}/top-penjualan");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => TopPenjualan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top penjualan');
    }
  }

  Future<List<RiwayatPenjualan>> fetchRiwayatPenjualan(String? token) async {
    final url = ApiUrl.buildUrl(ApiUrl.penjualanByUser);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => RiwayatPenjualan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load riwayat penjualan');
    }
  }

  Future<Map<String, dynamic>> getUserPercentage(String token) async {
    final url = ApiUrl.buildUrl(ApiUrl.pencapaian);
    print("Hello");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Memeriksa apakah status code sukses
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body); // Mengembalikan data JSON
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> claimBonus(String token) async {
    final url = ApiUrl.buildUrl(ApiUrl.klaimBonus);
    print("Hello claim");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Memeriksa apakah status code sukses
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body); 
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
