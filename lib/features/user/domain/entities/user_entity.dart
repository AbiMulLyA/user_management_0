// ============================================================================
// FILE: user_entity.dart
// DESKRIPSI: Entity User - representasi data user di Domain Layer
// LOKASI: lib/features/user/domain/entities/
// ============================================================================
//
// ENTITY adalah representasi data di Domain Layer.
//
// PERBEDAAN ENTITY vs MODEL:
// - ENTITY: Data murni tanpa logic parsing (domain layer)
// - MODEL: Data dengan logic parsing JSON (data layer)
//
// MENGAPA MEMISAHKAN ENTITY DAN MODEL?
// 1. Domain layer tidak bergantung pada format data eksternal (JSON, XML, dll)
// 2. Jika format API berubah, hanya Model yang perlu diubah
// 3. Business logic bekerja dengan Entity, bukan format data spesifik
//
// EQUATABLE:
// Package equatable memudahkan perbandingan object.
// Tanpa equatable, user1 == user2 akan false meskipun datanya sama
// Dengan equatable, perbandingan berdasarkan props yang didefinisikan
//
// ============================================================================

import 'package:equatable/equatable.dart';

/// Entity User - representasi data user di domain layer
///
/// Entity ini TIDAK bergantung pada:
/// - Format data dari API (JSON)
/// - Database schema
/// - Implementasi UI
///
/// Entity hanya berisi data murni yang dibutuhkan oleh business logic
class UserEntity extends Equatable {
  // -------------------------------------------------------------------------
  // PROPERTIES
  // -------------------------------------------------------------------------
  // Semua properties menggunakan 'final' karena Entity bersifat IMMUTABLE
  // Immutable = tidak bisa diubah setelah dibuat
  // Untuk mengubah data, buat instance baru dengan nilai yang berbeda
  // -------------------------------------------------------------------------

  /// ID unik user (biasanya dari database/API)
  final String id;

  /// Nama lengkap user
  final String name;

  /// Alamat lengkap user
  final String address;

  /// Alamat email user
  final String email;

  /// Nomor telepon user
  final String phoneNumber;

  /// Nama kota tempat tinggal user
  final String city;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------
  // Menggunakan 'const' constructor untuk optimasi performa
  // 'required' memastikan semua parameter wajib diisi
  // -------------------------------------------------------------------------

  /// Constructor untuk membuat UserEntity
  /// Semua parameter wajib diisi (required)
  const UserEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  // -------------------------------------------------------------------------
  // EQUATABLE PROPS
  // -------------------------------------------------------------------------
  // props adalah list properties yang digunakan untuk perbandingan
  // Dua UserEntity dianggap sama jika semua props-nya sama
  //
  // Contoh:
  // user1 = UserEntity(id: '1', name: 'John', ...)
  // user2 = UserEntity(id: '1', name: 'John', ...)
  // user1 == user2 -> TRUE (karena props-nya sama)
  // -------------------------------------------------------------------------

  @override
  List<Object?> get props => [id, name, address, email, phoneNumber, city];
}
