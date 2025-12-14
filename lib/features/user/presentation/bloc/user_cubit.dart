// ============================================================================
// FILE: user_cubit.dart
// DESKRIPSI: Cubit untuk manage state user
// LOKASI: lib/features/user/presentation/bloc/
// ============================================================================
//
// CUBIT adalah state management dari package flutter_bloc.
//
// CUBIT vs BLOC:
// -------------------------------------------------------------------------
// CUBIT (lebih sederhana):          BLOC (lebih kompleks):
// - Menggunakan method              - Menggunakan Event
// - cubit.loadData()                - bloc.add(LoadDataEvent())
// - Cocok untuk kasus sederhana     - Cocok untuk kasus kompleks
//
// PERAN CUBIT:
// -------------------------------------------------------------------------
// 1. Menerima aksi dari UI (button click, form submit, dll)
// 2. Memanggil Use Case untuk business logic
// 3. Mengubah state berdasarkan response
// 4. UI otomatis rebuild saat state berubah
//
// ALUR:
// -------------------------------------------------------------------------
// User Click -> Cubit Method -> Use Case -> Repository -> API
//                  |
//                  v
//            emit(NewState) -> UI Rebuild
//
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/add_user_usecase.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import 'user_state.dart';

/// Cubit untuk manage state user
///
/// Cubit<UserState> artinya:
/// - Cubit ini mengelola state bertipe UserState
/// - emit() hanya bisa menerima UserState atau turunannya
class UserCubit extends Cubit<UserState> {
  // -------------------------------------------------------------------------
  // DEPENDENCIES (USE CASES)
  // -------------------------------------------------------------------------
  // Cubit bergantung pada Use Cases, BUKAN langsung ke Repository
  // Ini memastikan Cubit hanya tahu tentang "apa yang bisa dilakukan"
  // bukan "bagaimana melakukannya"
  // -------------------------------------------------------------------------

  /// Use case untuk mendapatkan daftar user
  final GetUsersUseCase getUsersUseCase;

  /// Use case untuk menambahkan user baru
  final AddUserUseCase addUserUseCase;

  /// Use case untuk mendapatkan daftar kota
  final GetCitiesUseCase getCitiesUseCase;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------
  // super(UserInitial()) -> Set state awal ke UserInitial
  // Artinya saat Cubit dibuat, state-nya adalah UserInitial
  // -------------------------------------------------------------------------

  /// Constructor dengan dependency injection
  UserCubit({
    required this.getUsersUseCase,
    required this.addUserUseCase,
    required this.getCitiesUseCase,
  }) : super(UserInitial());

  // =========================================================================
  // METHOD: loadData
  // =========================================================================

  /// Method untuk load semua data (users dan cities)
  ///
  /// Dipanggil saat:
  /// - Halaman pertama kali dibuka
  /// - User melakukan pull-to-refresh
  /// - Setelah berhasil menambahkan user
  Future<void> loadData() async {
    try {
      // ---------------------------------------------------------------------
      // LANGKAH 1: Emit Loading State
      // ---------------------------------------------------------------------
      // emit() adalah method dari Cubit untuk mengubah state
      // Setelah emit(), UI akan rebuild kalau state berubah
      // ---------------------------------------------------------------------
      emit(UserLoading());

      // ---------------------------------------------------------------------
      // LANGKAH 2: Load Data Secara Parallel
      // ---------------------------------------------------------------------
      // Future.wait() menjalankan multiple async operations bersamaan
      // Ini lebih cepat daripada await satu-satu
      //
      // Tanpa Future.wait (sequential):
      //   final users = await getUsersUseCase.execute();  // 1 detik
      //   final cities = await getCitiesUseCase.execute(); // 1 detik
      //   Total: 2 detik
      //
      // Dengan Future.wait (parallel):
      //   final results = await Future.wait([...]);  // Maksimal 1 detik
      // ---------------------------------------------------------------------
      final results = await Future.wait([
        getUsersUseCase.execute(),
        getCitiesUseCase.execute(),
      ]);

      // ---------------------------------------------------------------------
      // LANGKAH 3: Extract Results
      // ---------------------------------------------------------------------
      // results[0] = hasil dari getUsersUseCase
      // results[1] = hasil dari getCitiesUseCase
      // Perlu cast karena Future.wait returns List<dynamic>
      // ---------------------------------------------------------------------
      final users = results[0] as List<UserEntity>;
      final cities = results[1] as List<CityEntity>;

      // ---------------------------------------------------------------------
      // LANGKAH 4: Emit Loaded State
      // ---------------------------------------------------------------------
      // Buat state baru dengan data yang sudah di-load
      // filteredUsers = users karena belum ada filter
      // ---------------------------------------------------------------------
      emit(UserLoaded(
        users: users,
        filteredUsers: users,
        cities: cities,
      ));
    } catch (e) {
      // Jika error, emit error state
      emit(UserError(message: e.toString()));
    }
  }

  // =========================================================================
  // METHOD: searchUsers
  // =========================================================================

  /// Method untuk search user berdasarkan nama
  ///
  /// Parameter:
  /// - [query]: Kata kunci pencarian
  ///
  /// Contoh: searchUsers('john') akan filter user yang namanya mengandung 'john'
  void searchUsers(String query) {
    // Pastikan state saat ini adalah UserLoaded
    // Tidak bisa filter jika data belum di-load
    if (state is UserLoaded) {
      // Cast state ke UserLoaded untuk akses properties
      final currentState = state as UserLoaded;

      // ---------------------------------------------------------------------
      // LANGKAH 1: Filter Berdasarkan Query
      // ---------------------------------------------------------------------
      // .where() memfilter list berdasarkan kondisi
      // .contains() cek apakah string mengandung substring
      // .toLowerCase() untuk case-insensitive search
      // ---------------------------------------------------------------------
      final filteredUsers = currentState.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // ---------------------------------------------------------------------
      // LANGKAH 2: Apply City Filter (jika ada)
      // ---------------------------------------------------------------------
      // Setelah filter by query, apply juga filter by city
      // Ini memastikan kedua filter bekerja bersamaan
      // ---------------------------------------------------------------------
      final finalFilteredUsers = _applyFilters(
        filteredUsers,
        currentState.selectedCity,
      );

      // ---------------------------------------------------------------------
      // LANGKAH 3: Emit State Baru
      // ---------------------------------------------------------------------
      // Gunakan copyWith untuk menyalin state dengan beberapa perubahan
      // ---------------------------------------------------------------------
      emit(currentState.copyWith(
        searchQuery: query,
        filteredUsers: finalFilteredUsers,
      ));
    }
  }

  // =========================================================================
  // METHOD: filterByCity
  // =========================================================================

  /// Method untuk filter user berdasarkan kota
  ///
  /// Parameter:
  /// - [city]: Nama kota untuk filter, null untuk "Semua Kota"
  void filterByCity(String? city) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      // Terapkan search filter terlebih dahulu
      var filteredUsers = currentState.users.where((user) {
        return user.name
            .toLowerCase()
            .contains(currentState.searchQuery.toLowerCase());
      }).toList();

      // Terapkan city filter
      filteredUsers = _applyFilters(filteredUsers, city);

      emit(currentState.copyWith(
        selectedCity: city,
        filteredUsers: filteredUsers,
      ));
    }
  }

  // =========================================================================
  // METHOD: sortUsers
  // =========================================================================

  /// Method untuk sort users berdasarkan nama
  ///
  /// Toggle antara A-Z (ascending) dan Z-A (descending)
  void sortUsers() {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      // Toggle status sorting
      final isAscending = !currentState.isAscending;

      // Copy list untuk di-sort (jangan modifikasi list asli!)
      final sortedUsers = List<UserEntity>.from(currentState.filteredUsers);

      // Sort berdasarkan nama
      sortedUsers.sort((a, b) {
        return isAscending
            ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
            : b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });

      emit(currentState.copyWith(
        filteredUsers: sortedUsers,
        isAscending: isAscending,
      ));
    }
  }

  // =========================================================================
  // METHOD: addUser
  // =========================================================================

  /// Method untuk menambahkan user baru
  ///
  /// Parameter:
  /// - [user]: UserEntity yang akan ditambahkan
  ///
  /// Setelah berhasil, akan otomatis reload data
  Future<void> addUser(UserEntity user) async {
    try {
      // Panggil use case untuk menambahkan user
      await addUserUseCase.execute(user);

      // Reload data setelah berhasil menambahkan
      // Ini akan refresh list dengan user baru dari API
      await loadData();
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // =========================================================================
  // HELPER METHOD: _applyFilters
  // =========================================================================

  /// Helper method untuk apply filter kota
  ///
  /// Private method (diawali underscore) hanya untuk internal use
  ///
  /// Parameter:
  /// - [users]: List user yang akan difilter
  /// - [city]: Nama kota untuk filter, null untuk tidak filter
  ///
  /// Returns: List user yang sudah difilter
  List<UserEntity> _applyFilters(List<UserEntity> users, String? city) {
    // Jika city null atau kosong, return semua user
    if (city == null || city.isEmpty) {
      return users;
    }

    // Filter user yang kotanya sesuai
    return users.where((user) => user.city == city).toList();
  }
}
