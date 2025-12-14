import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../config/api/api_config.dart';
import '../../models/user_model.dart';
import '../../models/city_model.dart';

/// Remote Data Source untuk User
/// Bertugas untuk komunikasi dengan API
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(UserModel user);
  Future<List<CityModel>> getCities();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      // Melakukan GET request ke API
      final response = await client.get(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse response body menjadi List
        final List<dynamic> jsonList = json.decode(response.body);

        // Convert setiap item menjadi UserModel
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
      // Melakukan POST request ke API
      final response = await client.post(
        Uri.parse(ApiConfig.userUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse response menjadi UserModel
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
      // Melakukan GET request ke API City
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
