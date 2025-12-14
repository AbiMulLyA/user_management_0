/// Konfigurasi API untuk aplikasi
/// Berisi base URL dan endpoint yang digunakan
class ApiConfig {
  // Base URL untuk API
  static const String baseUrl =
      'https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate';

  // Endpoint untuk user
  static const String userEndpoint = '/user';

  // Endpoint untuk city
  static const String cityEndpoint = '/city';

  // Full URL
  static String get userUrl => '$baseUrl$userEndpoint';
  static String get cityUrl => '$baseUrl$cityEndpoint';
}
