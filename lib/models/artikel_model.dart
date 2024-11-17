class Artikel {
  final int id;
  final String judul;
  final String isi;
  final DateTime tanggal;
  final String foto;

  // Constructor to create an Artikel instance
  Artikel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.foto,
  });

  // Factory constructor to create an Artikel from a JSON object
  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      tanggal: DateTime.parse(json['tanggal']),
      foto: json['foto'],
    );
  }

  // Method to convert an Artikel instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal.toIso8601String(),
      'foto': foto,
    };
  }
}

