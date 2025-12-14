// ============================================================================
// PERTEMUAN 2: USER STATE - REPRESENTASI KONDISI UI
// ============================================================================
//
// STATE adalah gambaran kondisi UI pada satu waktu tertentu.
//
// MENGAPA PERLU STATE CLASS TERPISAH?
// -------------------------------------------------------------------------
// Di Pertemuan 1, kita menggunakan variabel terpisah:
//   bool isLoading = false;
//   String? errorMessage;
//   List<UserModel> users = [];
//
// Masalahnya:
// - Mudah lupa update salah satu variabel
// - Tidak ada jaminan konsistensi state
// - Sulit di-test
//
// Dengan State class:
// - Semua informasi terkait terkumpul dalam satu object
// - Lebih mudah di-manage dan di-test
// - Type-safe (compiler bisa cek)
//
// ============================================================================

import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

// =============================================================================
// BASE STATE CLASS
// =============================================================================

/// Base class untuk semua state
///
/// Abstract class yang di-extend oleh state konkrit.
/// Menggunakan Equatable agar bisa membandingkan state dengan benar.
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
/// State ini aktif saat:
/// - Aplikasi pertama kali dibuka
/// - Cubit baru saja dibuat
class UserInitial extends UserState {}

// =============================================================================
// STATE: Loading
// =============================================================================

/// State ketika sedang memuat data
///
/// UI biasanya menampilkan:
/// - Loading indicator (spinner)
/// - Skeleton loading
class UserLoading extends UserState {}

// =============================================================================
// STATE: Loaded (Success)
// =============================================================================

/// State ketika data berhasil dimuat
///
/// Menyimpan list user yang akan ditampilkan di UI
class UserLoaded extends UserState {
  /// Daftar user dari API
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
/// Menyimpan pesan error untuk ditampilkan ke user
class UserError extends UserState {
  /// Pesan error
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
