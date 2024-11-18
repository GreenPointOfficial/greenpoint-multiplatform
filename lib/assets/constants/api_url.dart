class ApiUrl {

  // Base URL and version
  static const String baseUrl = "https://bfdd-182-23-28-54.ngrok-free.app"; // Ganti dengan URL server Anda
  static const String apiVersion = "v1";

  // Full Base API URL
  static String get baseApiUrl => "$baseUrl/api/$apiVersion";

  // Authentication
  static const String register = "/register";
  static const String login = "/login";
  static const String logout = "/logout";
  static const String user = "/user";

  // Jenis Sampah
  static const String jenisSampah = "/jenis-sampah";

  // Lokasi
  static const String lokasiGreedy = "/tsp";
  static const String lokasi = "/lokasi";

  // Artikel
  static const String artikel = "/artikel";

  // Transaksi
  static const String transaksiTerbanyak = "/transaksi/terbanyak-bulan-ini";
  static const String transaksiUser = "/transaksi/user";

  // Penukaran Poin
  static const String poinTukar = "/poin/tukar";

  // Penjualan dan Klaim Struk
  static const String penjualanClaim = "/penjualan/{penjualan}/claim";

  // Utility to build full URL
  static String buildUrl(String endpoint) => "$baseApiUrl$endpoint";
}
