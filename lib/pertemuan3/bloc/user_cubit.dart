// ============================================================================
// PERTEMUAN 3: USER CUBIT - DENGAN REPOSITORY
// ============================================================================
//
// PERBEDAAN DARI PERTEMUAN 2:
// -------------------------------------------------------------------------
// Pertemuan 2: Cubit langsung panggil HTTP
// Pertemuan 3: Cubit panggil Repository (tidak tahu tentang HTTP)
//
// KEUNTUNGAN:
// 1. Cubit lebih fokus ke state management
// 2. Mudah testing dengan mock Repository
// 3. Separation of concerns lebih jelas
//
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/user_model.dart';
import '../data/models/city_model.dart';
import '../data/repositories/user_repository.dart';
import 'user_state.dart';

/// Cubit untuk manage state user
class UserCubit extends Cubit<UserState> {
  // -------------------------------------------------------------------------
  // DEPENDENCY: Repository
  // -------------------------------------------------------------------------
  // Cubit bergantung pada Repository (abstract class)
  // Tidak tahu implementasi konkritnya (bisa real API atau mock)
  // -------------------------------------------------------------------------
  final UserRepository repository;

  /// Constructor dengan dependency injection
  UserCubit({required this.repository}) : super(UserInitial());

  // =========================================================================
  // LOAD DATA
  // =========================================================================

  /// Load users dan cities dari repository
  Future<void> loadData() async {
    emit(UserLoading());

    try {
      // ---------------------------------------------------------------------
      // PARALLEL REQUEST dengan Future.wait
      // ---------------------------------------------------------------------
      // Lebih cepat daripada await satu-satu
      // ---------------------------------------------------------------------
      final results = await Future.wait([
        repository.getUsers(),
        repository.getCities(),
      ]);

      final users = results[0] as List<UserModel>;
      final cities = results[1] as List<CityModel>;

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
  // SEARCH USERS
  // =========================================================================

  /// Filter users berdasarkan nama
  void searchUsers(String query) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      final filtered = currentState.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Apply city filter juga
      final finalFiltered =
          _applyCityFilter(filtered, currentState.selectedCity);

      emit(currentState.copyWith(
        searchQuery: query,
        filteredUsers: finalFiltered,
      ));
    }
  }

  // =========================================================================
  // FILTER BY CITY
  // =========================================================================

  /// Filter users berdasarkan kota
  void filterByCity(String? city) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      // Apply search filter dulu
      var filtered = currentState.users.where((user) {
        return user.name
            .toLowerCase()
            .contains(currentState.searchQuery.toLowerCase());
      }).toList();

      // Apply city filter
      filtered = _applyCityFilter(filtered, city);

      emit(currentState.copyWith(
        selectedCity: city,
        filteredUsers: filtered,
      ));
    }
  }

  // =========================================================================
  // ADD USER
  // =========================================================================

  /// Tambah user baru
  Future<void> addUser(UserModel user) async {
    try {
      await repository.addUser(user);
      // Reload data setelah berhasil
      await loadData();
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // =========================================================================
  // HELPER
  // =========================================================================

  List<UserModel> _applyCityFilter(List<UserModel> users, String? city) {
    if (city == null || city.isEmpty) {
      return users;
    }
    return users.where((user) => user.city == city).toList();
  }
}
