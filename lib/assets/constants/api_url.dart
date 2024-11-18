class ApiUrl {

  // Base URL and version
  static const String baseUrl = "https://564d-182-1-18-29.ngrok-free.app"; 
  static const String apiVersion = "v1";

  // Full Base API URL
  static String get baseApiUrl => "$baseUrl/api/$apiVersion";
  static String get baseImageUrl => "$baseUrl/storage/";


  // Authentication
  static const String register = "/register";
  static const String login = "/login";
  static const String logout = "/logout";
  static const String user = "/user";

  // Jenis Sampah
  static const String jenisSampah = "/jenis-sampah";

  // Dampak
  static const String dampak = "/dampak";
  static const String daurUlang = "/daur-ulang";
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
