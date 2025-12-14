// ============================================================================
// PERTEMUAN 2: USER STATE - REPRESENTASI KONDISI UI
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 2!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 1.
//
// Di Pertemuan 1, state direpresentasikan dengan variabel terpisah:
//   bool isLoading = false;
//   String? errorMessage;
//   List<UserModel> users = [];
//
// Di Pertemuan 2, kita buat class khusus untuk setiap kondisi state:
//   UserInitial  → kondisi awal
//   UserLoading  → menggantikan isLoading = true
//   UserLoaded   → menggantikan users = [...]
//   UserError    → menggantikan errorMessage = "..."
//
// KEUNTUNGAN:
// - Lebih jelas dan type-safe
// - Tidak mungkin state tidak konsisten
// - Mudah di-test
//
// ============================================================================

import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

// =============================================================================
// BASE STATE CLASS
// =============================================================================

/// Base class untuk semua state
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

// =============================================================================
// STATE: Initial
// =============================================================================

/// State awal sebelum ada aksi apapun
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini adalah kondisi ketika:
/// - users = [] (kosong)
/// - isLoading = false
/// - errorMessage = null
class UserInitial extends UserState {}

// =============================================================================
// STATE: Loading
// =============================================================================

/// State ketika sedang memuat data
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini menggantikan: isLoading = true
class UserLoading extends UserState {}

// =============================================================================
// STATE: Loaded (Success)
// =============================================================================

/// State ketika data berhasil dimuat
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini menggantikan:
/// - users = [...] (data dari API)
/// - isLoading = false
/// - errorMessage = null
class UserLoaded extends UserState {
  /// Daftar user dari API
  /// 📌 DULU: variabel 'users' di _UserListPageState
  final List<UserModel> users;

  const UserLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

// =============================================================================
// STATE: Error
// =============================================================================

/// State ketika terjadi error
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini menggantikan:
/// - errorMessage = "..." (ada error)
/// - isLoading = false
class UserError extends UserState {
  /// Pesan error
  /// 📌 DULU: variabel 'errorMessage' di _UserListPageState
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
