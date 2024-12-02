import 'package:intl/intl.dart';

class RiwayatPenjualan {
  final int penjualanId;
  final DateTime tanggal;  // This is now a DateTime object
  final List<ItemPenjualan> items;
  final double totalBerat;

  RiwayatPenjualan({
    required this.penjualanId,
    required this.tanggal,
    required this.items,
    required this.totalBerat,
  });

  // Mengonversi response JSON menjadi objek RiwayatPenjualan
  factory RiwayatPenjualan.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<ItemPenjualan> itemsList = list.map((i) => ItemPenjualan.fromJson(i)).toList();

    // Check if tanggal is a String or a timestamp
    DateTime tanggalParsed;
    if (json['tanggal'] is String) {
      // If 'tanggal' is a String, parse it into DateTime
      tanggalParsed = DateTime.parse(json['tanggal']);
    } else if (json['tanggal'] is int) {
      // If 'tanggal' is a timestamp (in seconds), convert to DateTime
      tanggalParsed = DateTime.fromMillisecondsSinceEpoch(json['tanggal'] * 1000);
    } else {
      // Fallback in case the 'tanggal' is in an unexpected format
      throw FormatException("Unexpected format for 'tanggal'");
    }

    return RiwayatPenjualan(
      penjualanId: json['penjualan_id'],
      tanggal: tanggalParsed,  // Store the DateTime object
      items: itemsList,
      totalBerat: json['total_berat'].toDouble(),
    );
  }

  // Mengonversi objek RiwayatPenjualan menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'penjualan_id': penjualanId,
      'tanggal': tanggal.toIso8601String(),  // Store DateTime as ISO8601 string
      'items': items.map((item) => item.toJson()).toList(),
      'total_berat': totalBerat,
    };
  }

  // Format 'tanggal' to display only the year, month, and day
  String get formattedTanggal {
    return DateFormat('yyyy-MM-dd').format(tanggal); // Format as "yyyy-MM-dd"
  }
}

class ItemPenjualan {
  final int id;
  final int jenisSampahId;
  final int jumlah;
  final double totalHarga;
  final double berat;

  ItemPenjualan({
    required this.id,
    required this.jenisSampahId,
    required this.jumlah,
    required this.totalHarga,
    required this.berat,
  });

  // Mengonversi response JSON menjadi objek ItemPenjualan
  factory ItemPenjualan.fromJson(Map<String, dynamic> json) {
    return ItemPenjualan(
      id: json['id'],
      jenisSampahId: json['jenis_sampah_id'],
      jumlah: json['jumlah'],
      totalHarga: json['total_harga'].toDouble(),
      berat: json['berat'].toDouble(),
    );
  }

  // Mengonversi objek ItemPenjualan menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jenis_sampah_id': jenisSampahId,
      'jumlah': jumlah,
      'total_harga': totalHarga,
      'berat': berat,
    };
  }
}
