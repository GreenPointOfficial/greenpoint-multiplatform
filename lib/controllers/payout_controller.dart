import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/models/payout_model.dart';
import 'package:greenpoint/service/payout_service.dart';

class PayoutController extends ChangeNotifier {
  bool isProcessing = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final PayoutService _payoutService = PayoutService();

  Future<bool> createPayout({
    required double amount, // Pass the amount to be withdrawn
    required String accountNumber, // Account number to receive the payout
  }) async {
    final token = await _secureStorage.read(key: 'auth_token');
    print('Token: $token');

    if (token == null) {
      print('No token found');
      return false; // Return false if no token is found
    }

    isProcessing = true;
    notifyListeners();

    final payoutModel = PayoutModel(
      amount: amount,
      accountNumber: accountNumber,
    );

    try {
      final result = await _payoutService.createPayout(
        payoutModel: payoutModel,
        authToken: token,
      );

      if (result['success']) {
        print("Payout successful!");
        return true; // Return true if payout creation is successful
      } else {
        print("Payout failed: ${result['error']}");
        return false; // Return false if payout creation failed
      }
    } catch (e) {
      print('Error during payout: $e');
      return false; // Return false if an error occurs
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }
}
