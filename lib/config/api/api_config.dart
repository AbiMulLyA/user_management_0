// ============================================================================
// FILE: api_config.dart
// DESKRIPSI: Konfigurasi URL dan Endpoint API
// LOKASI: lib/config/api/
// ============================================================================
//
// File ini berisi konstanta-konstanta untuk API configuration.
// Dengan menempatkan konfigurasi API di satu tempat:
// 1. Mudah untuk mengubah URL jika backend berubah
// 2. Menghindari hardcode URL di banyak tempat
// 3. Lebih mudah untuk switch antara environment (dev, staging, production)
//
// ============================================================================

/// Kelas ApiConfig berisi semua konfigurasi yang berhubungan dengan API
/// Menggunakan static const agar bisa diakses tanpa membuat instance
class ApiConfig {
  // -------------------------------------------------------------------------
  // BASE URL
  // -------------------------------------------------------------------------
  // Base URL adalah alamat dasar dari API server
  // Semua endpoint akan ditambahkan di belakang base URL ini
  //
  // Contoh: https://example.com/api/v1 + /user = https://example.com/api/v1/user
  // -------------------------------------------------------------------------
  static const String baseUrl =
      'https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate';

  // -------------------------------------------------------------------------
  // ENDPOINT USER
  // -------------------------------------------------------------------------
  // Endpoint adalah path spesifik untuk mengakses resource tertentu
  // /user digunakan untuk operasi CRUD pada data user:
  // - GET /user     -> mendapatkan semua user
  // - POST /user    -> menambahkan user baru
  // - GET /user/:id -> mendapatkan user berdasarkan ID
  // -------------------------------------------------------------------------
  static const String userEndpoint = '/user';

  // -------------------------------------------------------------------------
  // ENDPOINT CITY
  // -------------------------------------------------------------------------
  // /city digunakan untuk mendapatkan daftar kota
  // - GET /city -> mendapatkan semua kota
  // -------------------------------------------------------------------------
  static const String cityEndpoint = '/city';

  // -------------------------------------------------------------------------
  // FULL URL (GETTER)
  // -------------------------------------------------------------------------
  // Getter ini menggabungkan baseUrl dengan endpoint
  // Menggunakan getter agar nilainya dihitung saat dipanggil
  //
  // Contoh penggunaan:
  // ApiConfig.userUrl -> "https://...../accurate/user"
  // -------------------------------------------------------------------------

  /// URL lengkap untuk endpoint user
  static String get userUrl => '$baseUrl$userEndpoint';

  /// URL lengkap untuk endpoint city
  static String get cityUrl => '$baseUrl$cityEndpoint';
}
