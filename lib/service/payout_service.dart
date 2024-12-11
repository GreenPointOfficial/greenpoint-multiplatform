import 'dart:convert';
import 'package:greenpoint/assets/constants/api_url.dart';
import 'package:greenpoint/models/payout_model.dart';
import 'package:http/http.dart' as http;

class PayoutService {
  Future<Map<String, dynamic>> createPayout({
    required PayoutModel payoutModel,
    required String? authToken,
  }) async {
    final url = ApiUrl.buildUrl(ApiUrl.poinTukar);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final body = jsonEncode({
      'amount': payoutModel.amount, 
      'account_number': payoutModel.accountNumber,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          print('Payout berhasil: ${responseData['data']}');
          return {'success': true, 'data': responseData['data']};
        } else {
          print('Error: ${responseData['error']}');
          return {'success': false, 'error': responseData['error']};
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return {'success': false, 'error': 'Request failed with status: ${response.statusCode}'};
      }
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}
