
class PenjualanModel {
  final int penjualan_id;
  final int user_id;

  PenjualanModel({
    required this.penjualan_id,
    required this.user_id,
  });

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    return PenjualanModel(
      penjualan_id: json['penjualan_id'],
      user_id: json['user_id'],
    );
  }
}
