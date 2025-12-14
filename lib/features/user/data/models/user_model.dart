import '../../domain/entities/user_entity.dart';

/// Model User - representasi data user dari API
/// Berisi logic untuk parsing JSON
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.address,
    required super.email,
    required super.phoneNumber,
    required super.city,
  });

  /// Factory method untuk membuat UserModel dari JSON
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

  /// Method untuk convert UserModel ke JSON
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
