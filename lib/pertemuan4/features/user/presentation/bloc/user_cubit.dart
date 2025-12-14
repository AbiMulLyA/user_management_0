// ============================================================================
// PERTEMUAN 4: USER CUBIT - SEKARANG MENGGUNAKAN USE CASES
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 3:
// ============================================================================
// Di Pertemuan 3, Cubit langsung panggil Repository.
// Di Pertemuan 4, Cubit panggil Use Cases.
//
// YANG DIPINDAHKAN/BERUBAH:
// - repository.getUsers()  → getUsersUseCase.execute()
// - repository.addUser()   → addUserUseCase.execute()
// - repository.getCities() → getCitiesUseCase.execute()
//
// YANG BARU:
// - UseCase sebagai dependency (bukan Repository)
// - Menggunakan Entity (bukan Model) di state
//
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/add_user_usecase.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import 'user_state.dart';

/// Cubit untuk manage state user
///
/// 🔄 PERUBAHAN: Sekarang menerima Use Cases, bukan Repository
class UserCubit extends Cubit<UserState> {
  // =========================================================================
  // 📌 JEJAK PERTEMUAN 3: Dependency berubah
  // =========================================================================
  // KODE LAMA (Pertemuan 3):
  // -----------------------------------------------------------------
  // final UserRepository repository;
  // UserCubit({required this.repository}) : super(UserInitial());
  //
  // SEKARANG (Pertemuan 4):
  // Use Cases sebagai dependency, bukan Repository langsung
  // =========================================================================
  final GetUsersUseCase getUsersUseCase;
  final AddUserUseCase addUserUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  UserCubit({
    required this.getUsersUseCase,
    required this.addUserUseCase,
    required this.getCitiesUseCase,
  }) : super(UserInitial());

  // =========================================================================
  // 📌 JEJAK PERTEMUAN 3: loadData() berubah isinya
  // =========================================================================
  // KODE LAMA (Pertemuan 3):
  // -----------------------------------------------------------------
  // Future<void> loadData() async {
  //   emit(UserLoading());
  //   try {
  //     final results = await Future.wait([
  //       repository.getUsers(),      // ← Langsung panggil Repository
  //       repository.getCities(),     // ← Langsung panggil Repository
  //     ]);
  //     ...
  //   }
  // }
  //
  // SEKARANG (Pertemuan 4):
  // Panggil Use Case, bukan Repository
  // =========================================================================

  Future<void> loadData() async {
    try {
      emit(UserLoading());

      // =====================================================================
      // 🔄 PERUBAHAN UTAMA:
      // Dulu (P3): repository.getUsers()
      // Sekarang:  getUsersUseCase.execute()
      //
      // Use Case bisa berisi business logic tambahan
      // misal validasi, transformasi, dll sebelum return data
      // =====================================================================
      final results = await Future.wait([
        getUsersUseCase.execute(), // 🔄 Dulu: repository.getUsers()
        getCitiesUseCase.execute(), // 🔄 Dulu: repository.getCities()
      ]);

      // 🔄 PERUBAHAN: Menggunakan Entity, bukan Model
      final users = results[0] as List<UserEntity>;
      final cities = results[1] as List<CityEntity>;

      emit(UserLoaded(
        users: users,
        filteredUsers: users,
        cities: cities,
      ));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // =========================================================================
  // SEARCH USERS (sama seperti Pertemuan 3)
  // =========================================================================
  void searchUsers(String query) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      final filteredUsers = currentState.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      final finalFilteredUsers = _applyFilters(
        filteredUsers,
        currentState.selectedCity,
      );

      emit(currentState.copyWith(
        searchQuery: query,
        filteredUsers: finalFilteredUsers,
      ));
    }
  }

  // =========================================================================
  // FILTER BY CITY (sama seperti Pertemuan 3)
  // =========================================================================
  void filterByCity(String? city) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      var filteredUsers = currentState.users.where((user) {
        return user.name
            .toLowerCase()
            .contains(currentState.searchQuery.toLowerCase());
      }).toList();

      filteredUsers = _applyFilters(filteredUsers, city);

      emit(currentState.copyWith(
        selectedCity: city,
        filteredUsers: filteredUsers,
      ));
    }
  }

  // =========================================================================
  // 🆕 BARU DI PERTEMUAN 4: SORT USERS
  // =========================================================================
  void sortUsers() {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final isAscending = !currentState.isAscending;

      final sortedUsers = List<UserEntity>.from(currentState.filteredUsers);
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
  // 📌 JEJAK PERTEMUAN 3: addUser() berubah
  // =========================================================================
  // KODE LAMA (Pertemuan 3):
  // -----------------------------------------------------------------
  // Future<void> addUser(UserModel user) async {
  //   await repository.addUser(user);  // ← Langsung panggil Repository
  // }
  //
  // SEKARANG: Panggil Use Case
  // =========================================================================
  Future<void> addUser(UserEntity user) async {
    try {
      // 🔄 PERUBAHAN:
      // Dulu (P3): await repository.addUser(user)
      // Sekarang:  await addUserUseCase.execute(user)
      await addUserUseCase.execute(user);
      await loadData();
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // =========================================================================
  // HELPER
  // =========================================================================
  List<UserEntity> _applyFilters(List<UserEntity> users, String? city) {
    if (city == null || city.isEmpty) {
      return users;
    }
    return users.where((user) => user.city == city).toList();
  }
}
