// ============================================================================
// PERTEMUAN 4: USER CUBIT - PRESENTATION LAYER
// ============================================================================
//
// Cubit sekarang bergantung pada USE CASES, bukan Repository langsung.
// Ini memastikan separation of concerns yang lebih baik.
//
// ALUR FINAL:
// UI -> Cubit -> UseCase -> Repository -> DataSource -> API
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
class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase getUsersUseCase;
  final AddUserUseCase addUserUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  UserCubit({
    required this.getUsersUseCase,
    required this.addUserUseCase,
    required this.getCitiesUseCase,
  }) : super(UserInitial());

  // =========================================================================
  // LOAD DATA
  // =========================================================================
  Future<void> loadData() async {
    try {
      emit(UserLoading());

      // Parallel request menggunakan Future.wait
      final results = await Future.wait([
        getUsersUseCase.execute(),
        getCitiesUseCase.execute(),
      ]);

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
  // SEARCH USERS
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
  // FILTER BY CITY
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
  // SORT USERS
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
  // ADD USER
  // =========================================================================
  Future<void> addUser(UserEntity user) async {
    try {
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
