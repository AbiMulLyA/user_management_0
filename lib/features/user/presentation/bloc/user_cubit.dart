import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/user_entity.dart';
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

  /// Method untuk load semua data (users dan cities)
  Future<void> loadData() async {
    try {
      emit(UserLoading());

      // Load users dan cities secara parallel
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

  /// Method untuk search user berdasarkan nama
  void searchUsers(String query) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      // Filter users berdasarkan query
      final filteredUsers = currentState.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Apply city filter jika ada
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

  /// Method untuk filter user berdasarkan kota
  void filterByCity(String? city) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      // Apply search filter terlebih dahulu
      var filteredUsers = currentState.users.where((user) {
        return user.name
            .toLowerCase()
            .contains(currentState.searchQuery.toLowerCase());
      }).toList();

      // Apply city filter
      filteredUsers = _applyFilters(filteredUsers, city);

      emit(currentState.copyWith(
        selectedCity: city,
        filteredUsers: filteredUsers,
      ));
    }
  }

  /// Method untuk sort users berdasarkan nama
  void sortUsers() {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final isAscending = !currentState.isAscending;

      // Copy list untuk di-sort
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

  /// Method untuk menambahkan user baru
  Future<void> addUser(UserEntity user) async {
    try {
      // Tambahkan user melalui use case
      await addUserUseCase.execute(user);

      // Reload data setelah berhasil menambahkan
      await loadData();
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  /// Helper method untuk apply filter
  List<UserEntity> _applyFilters(List<UserEntity> users, String? city) {
    if (city == null || city.isEmpty) {
      return users;
    }

    return users.where((user) => user.city == city).toList();
  }
}
