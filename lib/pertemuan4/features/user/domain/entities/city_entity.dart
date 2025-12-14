// ============================================================================
// PERTEMUAN 4: CITY ENTITY - DOMAIN LAYER
// ============================================================================

import 'package:equatable/equatable.dart';

/// Entity City - representasi data kota di domain layer
class CityEntity extends Equatable {
  final String id;
  final String name;

  const CityEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
