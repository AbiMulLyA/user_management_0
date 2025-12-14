// ============================================================================
// FILE: user_state.dart
// DESKRIPSI: State untuk UserCubit - merepresentasikan kondisi UI
// LOKASI: lib/features/user/presentation/bloc/
// ============================================================================
//
// STATE adalah representasi dari KONDISI UI pada suatu waktu.
//
// MENGAPA BUTUH STATE?
// -------------------------------------------------------------------------
// UI perlu tahu:
// - Apakah sedang loading?
// - Apakah ada error?
// - Data apa yang harus ditampilkan?
//
// State menjawab semua pertanyaan tersebut.
//
// JENIS STATE:
// -------------------------------------------------------------------------
// 1. UserInitial   - State awal sebelum apa-apa dilakukan
// 2. UserLoading   - Sedang memuat data
// 3. UserLoaded    - Data berhasil dimuat
// 4. UserError     - Terjadi error
//
// IMMUTABLE STATE:
// -------------------------------------------------------------------------
// State bersifat IMMUTABLE (tidak bisa diubah setelah dibuat)
// Untuk "mengubah" state, buat state baru dengan nilai berbeda
//
// Contoh:
// - Salah: state.users.add(newUser)  // mengubah state yang ada
// - Benar: emit(UserLoaded(users: [...oldUsers, newUser]))  // buat state baru
//
// ============================================================================

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';

// =============================================================================
// BASE STATE CLASS
// =============================================================================

/// Base class untuk semua state UserCubit
///
/// Abstract class yang di-extend oleh semua state konkrit.
/// Menggunakan Equatable agar Cubit bisa membandingkan state dengan benar.
///
/// MENGAPA PAKAI EQUATABLE?
/// Cubit menggunakan == untuk tahu apakah state berubah.
/// Tanpa Equatable, dua state dengan data sama akan dianggap berbeda.
abstract class UserState extends Equatable {
  /// Constructor const untuk optimasi
  const UserState();

  /// Props kosong sebagai default
  /// State turunan bisa override jika ada properties
  @override
  List<Object?> get props => [];
}

// =============================================================================
// STATE: UserInitial
// =============================================================================

/// State awal sebelum ada aksi apapun
///
/// State ini aktif saat:
/// - Aplikasi pertama kali dibuka
/// - Cubit baru saja dibuat
class UserInitial extends UserState {}

// =============================================================================
// STATE: UserLoading
// =============================================================================

/// State ketika sedang memuat data
///
/// State ini aktif saat:
/// - Sedang fetch data dari API
/// - Sedang menambahkan user baru
///
/// UI biasanya menampilkan:
/// - Loading indicator (spinner)
/// - Skeleton loading
class UserLoading extends UserState {}

// =============================================================================
// STATE: UserLoaded
// =============================================================================

/// State ketika data berhasil dimuat
///
/// State ini adalah yang paling kompleks karena menyimpan:
/// - Daftar semua user (asli dari API)
/// - Daftar user yang sudah difilter (untuk ditampilkan)
/// - Daftar kota untuk dropdown
/// - Query pencarian
/// - Kota yang dipilih untuk filter
/// - Status sorting
class UserLoaded extends UserState {
  // -------------------------------------------------------------------------
  // PROPERTIES
  // -------------------------------------------------------------------------

  /// Daftar SEMUA user dari API (tidak berubah setelah fetch)
  /// Digunakan sebagai sumber data asli untuk filtering
  final List<UserEntity> users;

  /// Daftar user yang sudah difilter (yang ditampilkan di UI)
  /// Berubah saat user melakukan search atau filter
  final List<UserEntity> filteredUsers;

  /// Daftar kota untuk dropdown filter
  final List<CityEntity> cities;

  /// Query pencarian yang diinput user
  /// Default empty string ''
  final String searchQuery;

  /// Kota yang dipilih untuk filter
  /// null artinya "Semua Kota"
  final String? selectedCity;

  /// Status sorting: true = A-Z, false = Z-A
  final bool isAscending;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor dengan default values
  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    required this.cities,
    this.searchQuery = '', // Default: tidak ada pencarian
    this.selectedCity, // Default: null (semua kota)
    this.isAscending = true, // Default: A-Z
  });

  // -------------------------------------------------------------------------
  // EQUATABLE PROPS
  // -------------------------------------------------------------------------

  /// Semua properties yang digunakan untuk perbandingan
  /// Jika salah satu berubah, Cubit akan rebuild UI
  @override
  List<Object?> get props => [
        users,
        filteredUsers,
        cities,
        searchQuery,
        selectedCity,
        isAscending,
      ];

  // -------------------------------------------------------------------------
  // COPY WITH METHOD
  // -------------------------------------------------------------------------

  /// Method untuk membuat salinan state dengan beberapa perubahan
  ///
  /// Karena state bersifat IMMUTABLE, kita tidak bisa mengubah nilai langsung.
  /// Sebaliknya, buat state baru dengan copyWith().
  ///
  /// Contoh penggunaan:
  /// ```dart
  /// // Hanya ubah searchQuery, property lain tetap sama
  /// final newState = currentState.copyWith(searchQuery: 'john');
  /// ```
  ///
  /// Parameter yang null akan menggunakan nilai dari state saat ini
  UserLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    List<CityEntity>? cities,
    String? searchQuery,
    String? selectedCity,
    bool? isAscending,
  }) {
    return UserLoaded(
      // Gunakan nilai baru jika ada, kalau tidak pakai nilai lama
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      cities: cities ?? this.cities,
      searchQuery: searchQuery ?? this.searchQuery,
      // selectedCity spesial: bisa null (artinya "Semua Kota")
      selectedCity: selectedCity,
      isAscending: isAscending ?? this.isAscending,
    );
  }
}

// =============================================================================
// STATE: UserError
// =============================================================================

/// State ketika terjadi error
///
/// State ini aktif saat:
/// - Gagal fetch data dari API
/// - Gagal menambahkan user
/// - Network error
/// - Server error
class UserError extends UserState {
  /// Pesan error yang akan ditampilkan ke user
  final String message;

  /// Constructor
  const UserError({required this.message});

  /// Props untuk perbandingan
  @override
  List<Object?> get props => [message];
}
