// ============================================================================
// PERTEMUAN 4: GET USERS USE CASE - DOMAIN LAYER
// ============================================================================
//
// USE CASE adalah class yang berisi business logic untuk SATU aksi spesifik.
//
// PRINSIP USE CASE:
// -------------------------------------------------------------------------
// 1. SINGLE RESPONSIBILITY: Setiap use case hanya melakukan SATU hal
// 2. BUSINESS LOGIC: Validasi, transformasi, aturan bisnis
// 3. ORCHESTRATION: Koordinasi satu atau lebih repository
//
// KENAPA PERLU USE CASE?
// -------------------------------------------------------------------------
// - Cubit hanya tahu "saya butuh users", use case yang eksekusi
// - Business logic terpusat, tidak tersebar di Cubit
// - Mudah di-test dan di-reuse
//
// ============================================================================

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list user
class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  /// Menjalankan use case
  Future<List<UserEntity>> execute() async {
    return await repository.getUsers();
  }
}
