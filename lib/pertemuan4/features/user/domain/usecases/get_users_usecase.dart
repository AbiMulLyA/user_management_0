// ============================================================================
// PERTEMUAN 4: GET USERS USE CASE - DOMAIN LAYER
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 4!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 3.
//
// Di Pertemuan 3, Cubit langsung panggil Repository:
//   final users = await repository.getUsers();
//
// Di Pertemuan 4, kita tambah layer Use Case di antara Cubit dan Repository:
//   Cubit → Use Case → Repository
//
// KENAPA PERLU USE CASE?
// 1. Single Responsibility: 1 use case = 1 aksi bisnis
// 2. Business Logic: Validasi, transformasi, aturan bisnis di sini
// 3. Reusable: Bisa dipanggil dari banyak Cubit
// 4. Testable: Mudah unit test karena fokus
//
// CONTOH PENGGUNAAN:
// Misal nanti ada aturan "hanya tampilkan user yang aktif",
// logicnya bisa ditambahkan di sini, bukan di Cubit.
//
// ============================================================================

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case untuk mendapatkan list user
///
/// 📌 JEJAK PERTEMUAN 3:
/// Di Pertemuan 3, Cubit langsung panggil: repository.getUsers()
/// Sekarang Cubit panggil: getUsersUseCase.execute()
class GetUsersUseCase {
  /// Repository dependency
  /// 🔄 Use Case bergantung pada Repository Interface (di Domain Layer)
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  /// Menjalankan use case
  ///
  /// 📌 MAPPING DARI PERTEMUAN 3:
  /// Dulu di Cubit: final users = await repository.getUsers();
  /// Sekarang di Cubit: final users = await getUsersUseCase.execute();
  ///
  /// Business logic bisa ditambahkan di sini, contoh:
  /// - Filter user yang tidak aktif
  /// - Sort berdasarkan nama
  /// - Validasi data
  Future<List<UserEntity>> execute() async {
    return await repository.getUsers();

    // Contoh jika ada business logic:
    // final users = await repository.getUsers();
    // return users.where((u) => u.isActive).toList();
  }
}
