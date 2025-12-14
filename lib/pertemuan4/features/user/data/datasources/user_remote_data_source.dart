// ============================================================================
// PERTEMUAN 4: DATA SOURCE - DATA LAYER
// ============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/api_config.dart';
import '../models/user_model.dart';
import '../models/city_model.dart';

/// Interface untuk Remote Data Source
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(UserModel user);
  Future<List<CityModel>> getCities();
}

/// Implementasi Remote Data Source
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

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
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error getting users: $e');
    }
  }

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
        throw Exception('Failed to add user');
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
