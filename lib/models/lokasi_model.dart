class LokasiModel {
  final int id;
  final String namaLokasi;
  final String alamat;
  final double latitude; 
  final double longitude;
  final String keterangan;

  LokasiModel({
    required this.id,
    required this.namaLokasi,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.keterangan,
  });

  // Factory method untuk membuat instance dari JSON
  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      id: json['id'],
      namaLokasi: json['nama_lokasi'],
      alamat: json['alamat'],
      latitude: double.parse(json['latitude']), // Parsing string ke double
      longitude: double.parse(json['longitude']), // Parsing string ke double
      keterangan: json['keterangan'],
    );
  }

  // Method untuk mengonversi instance ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_lokasi': namaLokasi,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'keterangan': keterangan,
    };
  }
}
