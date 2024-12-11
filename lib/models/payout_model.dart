class PayoutModel {
  final double amount;  // This represents the amount the user wants to withdraw
  final String accountNumber;  // The account number where the payout will be sent

  PayoutModel({
    required this.amount,
    required this.accountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'account_number': accountNumber,
    };
  }
}
