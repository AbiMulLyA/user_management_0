// ============================================================================
// PERTEMUAN 4: USER MODEL - DATA LAYER
// ============================================================================
//
// MODEL extends ENTITY dan menambahkan:
// - fromJson(): parsing dari JSON API
// - toJson(): konversi ke JSON untuk POST
//
// LISKOV SUBSTITUTION PRINCIPLE:
// - UserModel bisa digunakan di mana saja UserEntity bisa digunakan
// - Cubit/UseCase bekerja dengan UserEntity
// - DataSource bekerja dengan UserModel (untuk parsing)
//
// ============================================================================

import '../../domain/entities/user_entity.dart';

/// Model User - dengan parsing JSON
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.address,
    required super.email,
    required super.phoneNumber,
    required super.city,
  });

  /// Factory method untuk parsing JSON dari API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
    );
  }

  /// Method untuk konversi ke JSON (untuk POST request)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
    };
  }
}
