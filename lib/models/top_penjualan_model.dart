class TopPenjualan {
  final String userName;
  final double totalBerat;

  TopPenjualan({required this.userName, required this.totalBerat});

  // Mengonversi response JSON menjadi objek TopPenjualan
  factory TopPenjualan.fromJson(Map<String, dynamic> json) {
    return TopPenjualan(
      userName: json['user_name'],
      totalBerat: json['total_berat'].toDouble(),
    );
  }

  // Mengonversi objek TopPenjualan menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'total_berat': totalBerat,
    };
  }
}
