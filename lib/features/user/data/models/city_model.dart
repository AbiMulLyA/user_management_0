import '../../domain/entities/city_entity.dart';

/// Model City - representasi data kota dari API
class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.name,
  });

  /// Factory method untuk membuat CityModel dari JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
