class ApiUrl {
  // Base URL and version
  static const String baseUrl = "https://56db-114-125-15-8.ngrok-free.app";
  static const String apiVersion = "v1";

  // Full Base API URL
  static String get baseApiUrl => "$baseUrl/api/$apiVersion";
  static String get baseImageUrl => "$baseUrl/storage/";
  static String get baseImageUrlProfile => "$baseUrl/";

  // Authentication
  static const String register = "/register";
  static const String login = "/login";
  static const String changePass = "/change-password";
  static const String loginGoogle = "/auth/google/callback";
  static const String logout = "/logout";
  static const String user = "/user";
  static const String updateUser = "/user/update";
  static const String uploadImage = "/upload-image";

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

  // Penukaran Poin
  static const String poinTukar = "/create-payout";

  // Penjualan dan Klaim Struk
  static const String penjualanClaim = "/penjualan/{penjualan}/claim";
  static const String penjualanTop = "/penjualan/top-history";
  static const String penjualanByUser = "/penjualan/history";
  static const String pencapaian = "/penjualan/pencapaian";
  static const String klaimBonus = "/penjualan/pencapaian/claim";

  // Utility to build full URL
  static String buildUrl(String endpoint) => "$baseApiUrl$endpoint";
}
