// ============================================================================
// PERTEMUAN 3: USER MODEL - DENGAN toJson UNTUK POST
// ============================================================================

/// Model User dengan fromJson dan toJson
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

  /// Membuat UserModel dari JSON (untuk GET response)
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

  /// Konversi ke JSON (untuk POST request)
  ///
  /// ID tidak diinclude karena akan di-generate oleh server
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'city': city,
    };
  }
}
