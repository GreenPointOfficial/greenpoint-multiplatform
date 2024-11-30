// File: models/penjualan.dart

class PenjualanModel {
  final int penjualanId;
  final DateTime tanggal;
  final List<ItemPenjualan> items;

  PenjualanModel({
    required this.penjualanId,
    required this.tanggal,
    required this.items,
  });

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    return PenjualanModel(
      penjualanId: json['penjualan_id'],
      tanggal: DateTime.parse(json['tanggal']),
      items: (json['items'] as List<dynamic>)
          .map((item) => ItemPenjualan.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'penjualan_id': penjualanId,
      'tanggal': tanggal.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ItemPenjualan {
  final int id;
  final int penjualanId;
  final int jenisSampahId;
  final int jumlah;
  final int totalHarga;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemPenjualan({
    required this.id,
    required this.penjualanId,
    required this.jenisSampahId,
    required this.jumlah,
    required this.totalHarga,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method untuk mengonversi dari JSON ke Dart Object
  factory ItemPenjualan.fromJson(Map<String, dynamic> json) {
    return ItemPenjualan(
      id: json['id'],
      penjualanId: json['penjualan_id'],
      jenisSampahId: json['jenis_sampah_id'],
      jumlah: json['jumlah'],
      totalHarga: json['total_harga'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method untuk mengonversi dari Dart Object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'penjualan_id': penjualanId,
      'jenis_sampah_id': jenisSampahId,
      'jumlah': jumlah,
      'total_harga': totalHarga,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
