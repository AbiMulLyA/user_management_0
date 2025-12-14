// ============================================================================
// PERTEMUAN 3: CITY MODEL
// ============================================================================

/// Model City untuk dropdown filter
class CityModel {
  final String id;
  final String name;

  CityModel({
    required this.id,
    required this.name,
  });

  /// Membuat CityModel dari JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
