// ============================================================================
// PERTEMUAN 3: DATA SOURCE - KOMUNIKASI DENGAN API
// ============================================================================
//
// DATA SOURCE adalah class yang bertanggung jawab untuk:
// 1. Mengirim HTTP request ke API
// 2. Menerima response dari API
// 3. Mengkonversi JSON menjadi Model
//
// KENAPA DIPISAHKAN DARI REPOSITORY?
// -------------------------------------------------------------------------
// - DataSource: fokus ke HOW (bagaimana ambil data - HTTP, GraphQL, dll)
// - Repository: fokus ke WHAT (apa yang diambil - users, cities, dll)
//
// Dengan memisahkan:
// - Bisa ganti implementasi DataSource tanpa mengubah Repository
// - Bisa mock DataSource untuk testing
//
// ============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../models/user_model.dart';
import '../models/city_model.dart';

// =============================================================================
// ABSTRACT CLASS (INTERFACE)
// =============================================================================

/// Interface untuk Remote Data Source
///
/// Abstract class mendefinisikan KONTRAK:
/// - Method apa saja yang harus ada
/// - Return type yang diharapkan
abstract class UserRemoteDataSource {
  /// Get semua user dari API
  Future<List<UserModel>> getUsers();

  /// Tambah user baru ke API
  Future<UserModel> addUser(UserModel user);

  /// Get semua kota dari API
  Future<List<CityModel>> getCities();
}

// =============================================================================
// IMPLEMENTATION CLASS
// =============================================================================

/// Implementasi konkrit dari UserRemoteDataSource
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  /// HTTP Client untuk request
  final http.Client client;

  /// Constructor dengan dependency injection
  UserRemoteDataSourceImpl({required this.client});

  // -------------------------------------------------------------------------
  // GET USERS
  // -------------------------------------------------------------------------
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
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

  // -------------------------------------------------------------------------
  // ADD USER
  // -------------------------------------------------------------------------
  @override
  Future<UserModel> addUser(UserModel user) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
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

  // -------------------------------------------------------------------------
  // GET CITIES
  // -------------------------------------------------------------------------
  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConfig.cityUrl),
        headers: {'Content-Type': 'application/json'},
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
