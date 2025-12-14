// ============================================================================
// PERTEMUAN 3: USER CUBIT - SEKARANG MENGGUNAKAN REPOSITORY
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 2:
// ============================================================================
// Di Pertemuan 2, Cubit langsung melakukan HTTP request.
// Di Pertemuan 3, HTTP request DIPINDAHKAN ke DataSource.
// Cubit sekarang hanya panggil Repository.
//
// YANG DIPINDAHKAN:
// - http.get()      → data/datasources/user_remote_data_source.dart
// - json.decode()   → data/datasources/user_remote_data_source.dart
// - URL API         → config/api_config.dart
//
// YANG BARU:
// - Repository sebagai dependency
// - Method searchUsers(), filterByCity(), addUser()
//
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/user_model.dart';
import '../data/models/city_model.dart';
import '../data/repositories/user_repository.dart';
import 'user_state.dart';

/// Cubit untuk manage state user
///
/// 🔄 PERUBAHAN: Sekarang menerima Repository, bukan HTTP Client langsung
class UserCubit extends Cubit<UserState> {
  // =========================================================================
  // 🆕 BARU DI PERTEMUAN 3: Dependency pada Repository
  // =========================================================================
  // Di Pertemuan 2, tidak ada dependency. Cubit langsung panggil HTTP.
  // Sekarang Cubit bergantung pada Repository (abstract class).
  // =========================================================================
  final UserRepository repository;

  /// Constructor dengan dependency injection
  ///
  /// 🔄 PERUBAHAN:
  /// Pertemuan 2: UserCubit() : super(UserInitial());
  /// Pertemuan 3: UserCubit({required this.repository}) : super(UserInitial());
  UserCubit({required this.repository}) : super(UserInitial());

  // =========================================================================
  // 📌 JEJAK PERTEMUAN 2: loadUsers() → loadData()
  // =========================================================================
  // Method ini ada di Pertemuan 2, tapi ISINYA BERUBAH.
  // HTTP request DIPINDAHKAN ke: data/datasources/user_remote_data_source.dart
  //
  // KODE LAMA (Pertemuan 2):
  // -----------------------------------------------------------------
  // Future<void> loadUsers() async {
  //   emit(UserLoading());
  //   try {
  //     final response = await http.get(           // ← DIPINDAHKAN
  //       Uri.parse('https://627e360ab75a25d3f3b37d5a.mockapi.io/...'),
  //     );
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonList = json.decode(response.body); // ← DIPINDAHKAN
  //       final users = jsonList.map((json) => UserModel.fromJson(json)).toList();
  //       emit(UserLoaded(users: users));
  //     }
  //   } catch (e) {
  //     emit(UserError(message: e.toString()));
  //   }
  // }
  //
  // SEKARANG (Pertemuan 3):
  // Cukup panggil repository.getUsers() - tidak perlu tahu detail HTTP!
  // =========================================================================

  /// Load users dan cities dari repository
  Future<void> loadData() async {
    emit(UserLoading());

    try {
      // =====================================================================
      // 🔄 PERUBAHAN UTAMA:
      // Dulu (P2): final response = await http.get(...) + json.decode()
      // Sekarang:  final users = await repository.getUsers()
      //
      // Cubit tidak perlu tahu tentang HTTP, URL, atau JSON parsing!
      // Semua itu sekarang ditangani oleh DataSource.
      // =====================================================================
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
  // 🆕 METHOD BARU DI PERTEMUAN 3 (tidak ada di Pertemuan 2)
  // =========================================================================

  /// Filter users berdasarkan nama
  /// 🆕 BARU: Tidak ada di Pertemuan 2
  void searchUsers(String query) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      final filtered = currentState.users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      final finalFiltered =
          _applyCityFilter(filtered, currentState.selectedCity);

      emit(currentState.copyWith(
        searchQuery: query,
        filteredUsers: finalFiltered,
      ));
    }
  }

  /// Filter users berdasarkan kota
  /// 🆕 BARU: Tidak ada di Pertemuan 2
  void filterByCity(String? city) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      var filtered = currentState.users.where((user) {
        return user.name
            .toLowerCase()
            .contains(currentState.searchQuery.toLowerCase());
      }).toList();

      filtered = _applyCityFilter(filtered, city);

      emit(currentState.copyWith(
        selectedCity: city,
        filteredUsers: filtered,
      ));
    }
  }

  /// Tambah user baru
  /// 🆕 BARU: Tidak ada di Pertemuan 2
  Future<void> addUser(UserModel user) async {
    try {
      await repository.addUser(user);
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
