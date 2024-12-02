class ApiUrl {

  // Base URL and version
  static const String baseUrl = "https://9a12-125-162-86-240.ngrok-free.app"; 
  static const String apiVersion = "v1";

  // Full Base API URL
  static String get baseApiUrl => "$baseUrl/api/$apiVersion";
  static String get baseImageUrl => "$baseUrl/storage/";


  // Authentication
  static const String register = "/register";
  static const String login = "/login";
  static const String loginGoogle = "/auth/google/callback";
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
  // static const String transaksiUser = "/transaksi/user";

  // Penukaran Poin
  static const String poinTukar = "/poin/tukar";

  // Penjualan dan Klaim Struk
  static const String penjualanClaim = "/penjualan/{penjualan}/claim";
  static const String penjualanTop = "/penjualan/top-history";
  static const String penjualanByUser = "/penjualan/history";
  static const String pencapaian = "/penjualan/pencapaian";

  // Utility to build full URL
  static String buildUrl(String endpoint) => "$baseApiUrl$endpoint";
}
