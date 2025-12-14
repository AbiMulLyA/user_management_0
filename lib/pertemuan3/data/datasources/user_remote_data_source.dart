// ============================================================================
// PERTEMUAN 3: DATA SOURCE - KOMUNIKASI DENGAN API
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 3!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 2.
//
// Di Pertemuan 2, HTTP request ada di dalam Cubit:
//   final response = await http.get(Uri.parse('...'));
//   final jsonList = json.decode(response.body);
//
// Di Pertemuan 3, HTTP request DIPINDAHKAN ke sini:
// - Semua logic HTTP ada di DataSource
// - Cubit hanya panggil repository.getUsers()
// - Repository panggil dataSource.getUsers()
//
// KEUNTUNGAN:
// - Cubit tidak perlu tahu tentang HTTP
// - Mudah mock untuk testing
// - Bisa ganti implementasi (misal: GraphQL) tanpa ubah Cubit
//
// ============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../config/api_logger.dart';
import '../models/user_model.dart';
import '../models/city_model.dart';

// =============================================================================
// ABSTRACT CLASS (INTERFACE)
// =============================================================================

/// Interface untuk Remote Data Source
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(UserModel user);
  Future<List<CityModel>> getCities();
}

// =============================================================================
// IMPLEMENTATION CLASS
// =============================================================================

/// Implementasi Remote Data Source
///
/// 📌 KODE INI DIPINDAHKAN DARI: bloc/user_cubit.dart (Pertemuan 2)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  /// HTTP Client untuk request
  /// 🆕 BARU: Di-inject dari luar (Dependency Injection)
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  // =========================================================================
  // 📌 JEJAK PERTEMUAN 2: Kode ini DULU ada di UserCubit.loadUsers()
  // =========================================================================
  // KODE LAMA di UserCubit (Pertemuan 2):
  // -----------------------------------------------------------------
  // final response = await http.get(
  //   Uri.parse('https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate/user'),
  //   headers: {'Content-Type': 'application/json'},
  // );
  // if (response.statusCode == 200) {
  //   final List<dynamic> jsonList = json.decode(response.body);
  //   final users = jsonList.map((json) => UserModel.fromJson(json)).toList();
  // }
  //
  // SEKARANG: Kode tersebut ada di sini, di DataSource
  // =========================================================================
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      // 🔄 Kode ini dulu di UserCubit.loadUsers()
      final response = await client.get(
        Uri.parse(ApiConfig.userUrl), // 🆕 URL sekarang di ApiConfig
        headers: {'Content-Type': 'application/json'},
      );

      // 🆕 Menggunakan ApiLogger untuk logging yang konsisten
      ApiLogger.logComplete(
        method: 'GET',
        url: ApiConfig.userUrl,
        response: response,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting users: $e');
    }
  }

  // =========================================================================
  // 🆕 METHOD BARU DI PERTEMUAN 3
  // =========================================================================

  @override
  Future<UserModel> addUser(UserModel user) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      // 🆕 Menggunakan ApiLogger untuk logging yang konsisten
      ApiLogger.logComplete(
        method: 'POST',
        url: ApiConfig.userUrl,
        response: response,
        requestBody: json.encode(user.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConfig.cityUrl),
        headers: {'Content-Type': 'application/json'},
      );

      // 🆕 Menggunakan ApiLogger untuk logging yang konsisten
      ApiLogger.logComplete(
        method: 'GET',
        url: ApiConfig.cityUrl,
        response: response,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CityModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting cities: $e');
    }
  }
}
