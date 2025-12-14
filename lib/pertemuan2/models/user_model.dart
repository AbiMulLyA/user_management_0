// ============================================================================
// PERTEMUAN 2: MODEL USER (SAMA DENGAN PERTEMUAN 1)
// ============================================================================

/// Model User sederhana
class UserModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final String city;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.city,
  });

  /// Membuat UserModel dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
