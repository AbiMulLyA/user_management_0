// ============================================================================
// FILE: user_remote_data_source.dart
// DESKRIPSI: Remote Data Source - komunikasi dengan API
// LOKASI: lib/features/user/data/datasources/remote/
// ============================================================================
//
// DATA SOURCE adalah class yang bertanggung jawab untuk:
// 1. Berkomunikasi dengan sumber data (API, Database, Cache)
// 2. Mengkonversi response menjadi Model
// 3. Menghandle error dari sumber data
//
// JENIS DATA SOURCE:
// -------------------------------------------------------------------------
// 1. Remote Data Source - komunikasi dengan API (internet)
// 2. Local Data Source - komunikasi dengan database lokal (SQLite, Hive)
// 3. Cache Data Source - penyimpanan sementara untuk performa
//
// PATTERN YANG DIGUNAKAN:
// -------------------------------------------------------------------------
// - Abstract class untuk interface (contract)
// - Implementation class untuk logic konkrit
// - Ini memungkinkan mock data source untuk testing
//
// ============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../config/api/api_config.dart';
import '../../models/user_model.dart';
import '../../models/city_model.dart';

// =============================================================================
// ABSTRACT CLASS (INTERFACE)
// =============================================================================

/// Remote Data Source interface untuk User
///
/// Abstract class ini mendefinisikan KONTRAK:
/// - Method apa saja yang harus ada
/// - Parameter dan return type yang diharapkan
///
/// Implementation class (UserRemoteDataSourceImpl) harus mengimplementasikan
/// semua method yang didefinisikan di sini.
abstract class UserRemoteDataSource {
  /// Mendapatkan semua user dari API
  Future<List<UserModel>> getUsers();

  /// Menambahkan user baru ke API
  Future<UserModel> addUser(UserModel user);

  /// Mendapatkan semua kota dari API
  Future<List<CityModel>> getCities();
}

// =============================================================================
// IMPLEMENTATION CLASS
// =============================================================================

/// Implementasi konkrit dari UserRemoteDataSource
///
/// Class ini berisi logic untuk:
/// - Melakukan HTTP requests (GET, POST, PUT, DELETE)
/// - Parsing JSON response menjadi Model
/// - Handling error dari API
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // -------------------------------------------------------------------------
  // DEPENDENCY
  // -------------------------------------------------------------------------

  /// HTTP Client untuk melakukan request
  /// Diinjeksi melalui constructor agar bisa di-mock saat testing
  final http.Client client;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor dengan dependency injection
  UserRemoteDataSourceImpl({required this.client});

  // -------------------------------------------------------------------------
  // GET USERS
  // -------------------------------------------------------------------------

  /// Mendapatkan semua user dari API
  ///
  /// HTTP Method: GET
  /// Endpoint: /user
  ///
  /// Returns: List<UserModel> berisi semua user
  /// Throws: Exception jika request gagal
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      // ---------------------------------------------------------------------
      // LANGKAH 1: Melakukan HTTP GET Request
      // ---------------------------------------------------------------------
      // Uri.parse() mengkonversi string URL menjadi Uri object
      // Headers menentukan format yang diinginkan (JSON)
      // ---------------------------------------------------------------------
      final response = await client.get(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
      );

      // ---------------------------------------------------------------------
      // LANGKAH 2: Cek Status Code Response
      // ---------------------------------------------------------------------
      // Status Code 200 = OK (request berhasil)
      // Status Code 201 = Created (untuk POST request)
      // Status Code 400 = Bad Request
      // Status Code 401 = Unauthorized
      // Status Code 404 = Not Found
      // Status Code 500 = Internal Server Error
      // ---------------------------------------------------------------------
      if (response.statusCode == 200) {
        // -------------------------------------------------------------------
        // LANGKAH 3: Parse JSON Response
        // -------------------------------------------------------------------
        // json.decode() mengkonversi string JSON menjadi Dart object
        // Response berupa array, jadi hasilnya List<dynamic>
        // Contoh response: [{"id":"1","name":"John"}, {"id":"2","name":"Jane"}]
        // -------------------------------------------------------------------
        final List<dynamic> jsonList = json.decode(response.body);

        // -------------------------------------------------------------------
        // LANGKAH 4: Convert JSON ke Model
        // -------------------------------------------------------------------
        // .map() mengiterasi setiap item dan mengkonversi ke UserModel
        // .toList() mengkonversi hasil map menjadi List
        // -------------------------------------------------------------------
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        // Jika status code bukan 200, throw exception
        throw Exception('Failed to load users');
      }
    } catch (e) {
      // Catch semua error dan wrap dengan pesan yang lebih informatif
      throw Exception('Error getting users: $e');
    }
  }

  // -------------------------------------------------------------------------
  // ADD USER
  // -------------------------------------------------------------------------

  /// Menambahkan user baru ke API
  ///
  /// HTTP Method: POST
  /// Endpoint: /user
  /// Body: JSON data user
  ///
  /// Parameter:
  /// - [user]: UserModel yang akan ditambahkan
  ///
  /// Returns: UserModel yang berhasil ditambahkan (dengan ID dari server)
  /// Throws: Exception jika request gagal
  @override
  Future<UserModel> addUser(UserModel user) async {
    try {
      // ---------------------------------------------------------------------
      // LANGKAH 1: Melakukan HTTP POST Request
      // ---------------------------------------------------------------------
      // POST request mengirim data ke server
      // body: berisi JSON data yang akan dikirim
      // json.encode() mengkonversi Map Dart menjadi string JSON
      // ---------------------------------------------------------------------
      final response = await client.post(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      // ---------------------------------------------------------------------
      // LANGKAH 2: Cek Status Code
      // ---------------------------------------------------------------------
      // Status 201 (Created) atau 200 (OK) dianggap berhasil
      // Beberapa API menggunakan 200, yang lain 201 untuk create
      // ---------------------------------------------------------------------
      if (response.statusCode == 201 || response.statusCode == 200) {
        // -------------------------------------------------------------------
        // LANGKAH 3: Parse Response
        // -------------------------------------------------------------------
        // Server biasanya mengembalikan data yang baru saja dibuat
        // termasuk ID yang di-generate oleh server
        // -------------------------------------------------------------------
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  // -------------------------------------------------------------------------
  // GET CITIES
  // -------------------------------------------------------------------------

  /// Mendapatkan semua kota dari API
  ///
  /// HTTP Method: GET
  /// Endpoint: /city
  ///
  /// Returns: List<CityModel> berisi semua kota
  /// Throws: Exception jika request gagal
  @override
  Future<List<CityModel>> getCities() async {
    try {
      // Sama seperti getUsers, tapi untuk endpoint city
      final response = await client.get(
        Uri.parse(ApiConfig.cityUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CityModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      throw Exception('Error getting cities: $e');
    }
  }
}
