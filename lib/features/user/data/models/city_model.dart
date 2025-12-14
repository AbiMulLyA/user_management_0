// ============================================================================
// FILE: city_model.dart
// DESKRIPSI: Model City - representasi data kota dari API
// LOKASI: lib/features/user/data/models/
// ============================================================================
//
// Model sederhana untuk data kota.
// Hanya memiliki fromJson karena tidak ada operasi POST untuk city.
//
// ============================================================================

import '../../domain/entities/city_entity.dart';

/// Model City - representasi data kota dari API
///
/// Model ini hanya memiliki fromJson() karena:
/// - Kita hanya READ data kota dari API
/// - Tidak ada fitur untuk CREATE/UPDATE/DELETE kota
class CityModel extends CityEntity {
  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor untuk membuat CityModel
  const CityModel({
    required super.id, // Dikirim ke CityEntity.id
    required super.name, // Dikirim ke CityEntity.name
  });

  // -------------------------------------------------------------------------
  // FACTORY CONSTRUCTOR: fromJson
  // -------------------------------------------------------------------------

  /// Factory method untuk membuat CityModel dari JSON
  ///
  /// Parameter:
  /// - [json]: Map yang berisi data kota dari API
  ///
  /// Contoh JSON dari API:
  /// ```json
  /// {"id": "1", "name": "Jakarta"}
  /// ```
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
