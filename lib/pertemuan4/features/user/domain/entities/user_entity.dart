// ============================================================================
// PERTEMUAN 4: USER ENTITY - DOMAIN LAYER
// ============================================================================
//
// ENTITY adalah representasi data di Domain Layer.
//
// PERBEDAAN ENTITY vs MODEL:
// -------------------------------------------------------------------------
// | Aspek          | Entity              | Model                          |
// |----------------|---------------------|--------------------------------|
// | Layer          | Domain              | Data                           |
// | Tanggung Jawab | Data murni          | Parsing JSON                   |
// | Dependencies   | Tidak ada           | Extends Entity                 |
// | Method         | Tidak ada           | fromJson(), toJson()           |
// -------------------------------------------------------------------------
//
// KENAPA DIPISAHKAN?
// - Domain layer tidak bergantung pada format data eksternal
// - Jika format API berubah, hanya Model yang perlu diubah
// - Business logic bekerja dengan Entity, bukan format data
//
// ============================================================================

import 'package:equatable/equatable.dart';

/// Entity User - representasi data user di domain layer
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String city;

  const UserEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  @override
  List<Object?> get props => [id, name, address, email, phoneNumber, city];
}
