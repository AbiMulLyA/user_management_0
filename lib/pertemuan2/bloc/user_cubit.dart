// ============================================================================
// PERTEMUAN 2: USER CUBIT - STATE MANAGEMENT
// ============================================================================
//
// CUBIT adalah state management dari package flutter_bloc.
//
// PERBEDAAN STATEFULWIDGET vs CUBIT:
// -------------------------------------------------------------------------
// StatefulWidget (Pertemuan 1):
// - State terikat dengan 1 widget
// - setState() untuk update UI
// - Sulit share state ke widget lain
//
// Cubit (Pertemuan 2):
// - State terpisah dari widget
// - emit() untuk update state
// - Mudah share state via BlocProvider
// - Lebih mudah di-test
//
// MASIH BELUM IDEAL:
// -------------------------------------------------------------------------
// - HTTP request masih langsung di Cubit
// - Seharusnya ada Repository sebagai perantara
// - Akan diperbaiki di Pertemuan 3
//
// ============================================================================

import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'user_state.dart';

/// Cubit untuk manage state user
///
/// Cubit<UserState> artinya:
/// - Cubit ini mengelola state bertipe UserState
/// - emit() hanya bisa menerima UserState atau turunannya
class UserCubit extends Cubit<UserState> {
  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------
  // super(UserInitial()) -> Set state awal ke UserInitial
  // Artinya saat Cubit dibuat, state-nya adalah UserInitial
  // -------------------------------------------------------------------------

  UserCubit() : super(UserInitial());

  // =========================================================================
  // METHOD: loadUsers
  // =========================================================================

  /// Method untuk load data user dari API
  ///
  /// ALUR:
  /// 1. Emit UserLoading -> UI tampilkan loading
  /// 2. Fetch data dari API
  /// 3. Parse response
  /// 4. Emit UserLoaded atau UserError
  ///
  /// ⚠️ CATATAN:
  /// HTTP request masih di sini. Di Pertemuan 3, kita akan pindahkan
  /// ke Repository agar Cubit tidak perlu tahu tentang HTTP/API.
  Future<void> loadUsers() async {
    // -----------------------------------------------------------------------
    // LANGKAH 1: Emit Loading State
    // -----------------------------------------------------------------------
    // emit() adalah method dari Cubit untuk mengubah state
    // Setelah emit(), semua BlocBuilder akan rebuild
    // -----------------------------------------------------------------------
    emit(UserLoading());

    try {
      // ---------------------------------------------------------------------
      // LANGKAH 2: Fetch Data dari API
      // ---------------------------------------------------------------------
      // ⚠️ Masih hardcode URL di sini - akan diperbaiki nanti
      // ---------------------------------------------------------------------
      final response = await http.get(
        Uri.parse(
            'https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate/user'),
        headers: {'Content-Type': 'application/json'},
      );

      // ---------------------------------------------------------------------
      // LANGKAH 3: Cek Status dan Parse Response
      // ---------------------------------------------------------------------
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<UserModel> users =
            jsonList.map((json) => UserModel.fromJson(json)).toList();

        // -------------------------------------------------------------------
        // LANGKAH 4: Emit Loaded State dengan Data
        // -------------------------------------------------------------------
        emit(UserLoaded(users: users));
      } else {
        emit(UserError(
            message: 'Gagal memuat data. Status: ${response.statusCode}'));
      }
    } catch (e) {
      // Error handling
      emit(UserError(message: 'Terjadi kesalahan: $e'));
    }
  }

  // =========================================================================
  // METHOD: refreshUsers
  // =========================================================================

  /// Method untuk refresh data (sama dengan loadUsers)
  ///
  /// Dipanggil saat:
  /// - Pull-to-refresh
  /// - Tap tombol refresh
  Future<void> refreshUsers() async {
    await loadUsers();
  }
}
