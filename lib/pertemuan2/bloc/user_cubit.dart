// ============================================================================
// PERTEMUAN 2: USER CUBIT - STATE MANAGEMENT
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 2!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 1.
// Di Pertemuan 1, semua logic ada di dalam user_list_page.dart
//
// Di Pertemuan 2, kita MEMINDAHKAN logic ke sini:
// - fetchUsers() dari Page → loadUsers() di Cubit
// - State management dari setState() → emit()
//
// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'user_state.dart';

/// Cubit untuk manage state user
///
/// 🆕 BARU: Class ini tidak ada di Pertemuan 1
/// Semua logic yang dulu di Page, sekarang di sini.
class UserCubit extends Cubit<UserState> {
  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------
  // super(UserInitial()) → Set state awal
  // 🔄 Ini menggantikan: users = [], isLoading = false, errorMessage = null
  // -------------------------------------------------------------------------

  UserCubit() : super(UserInitial());

  // =========================================================================
  // 📌 JEJAK DARI PERTEMUAN 1: fetchUsers() → loadUsers()
  // =========================================================================
  // Method ini DIPINDAHKAN dari: pages/user_list_page.dart
  //
  // PERUBAHAN:
  // - Nama: fetchUsers() → loadUsers()
  // - setState({isLoading: true}) → emit(UserLoading())
  // - setState({users: data}) → emit(UserLoaded(users: data))
  // - setState({errorMessage: e}) → emit(UserError(message: e))
  // =========================================================================

  /// Method untuk load data user dari API
  ///
  /// 🔄 DULU di Pertemuan 1 bernama fetchUsers() dan ada di Page
  Future<void> loadUsers() async {
    // -----------------------------------------------------------------------
    // 🔄 PERUBAHAN:
    // Dulu: setState(() { isLoading = true; errorMessage = null; });
    // Sekarang: emit(UserLoading());
    // -----------------------------------------------------------------------
    emit(UserLoading());

    try {
      // ---------------------------------------------------------------------
      // ⚠️ HTTP request masih di sini (belum ideal)
      // Di Pertemuan 3, ini akan dipindahkan ke DataSource
      // ---------------------------------------------------------------------
      final response = await http.get(
        Uri.parse(
            'https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate/user'),
        headers: {'Content-Type': 'application/json'},
      );

      // Debug print untuk melihat response API
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint('│ 🌐 API REQUEST');
      debugPrint('├─────────────────────────────────────────────────────────');
      debugPrint('│ Method: GET');
      debugPrint(
          '│ URL: https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate/user');
      debugPrint('├─────────────────────────────────────────────────────────');
      debugPrint('│ 📥 API RESPONSE');
      debugPrint('├─────────────────────────────────────────────────────────');
      debugPrint('│ Status Code: ${response.statusCode}');
      debugPrint('│ Body: ${response.body}');
      debugPrint('└─────────────────────────────────────────────────────────');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<UserModel> users =
            jsonList.map((json) => UserModel.fromJson(json)).toList();

        // -------------------------------------------------------------------
        // 🔄 PERUBAHAN:
        // Dulu: setState(() { this.users = users; isLoading = false; });
        // Sekarang: emit(UserLoaded(users: users));
        // -------------------------------------------------------------------
        emit(UserLoaded(users: users));
      } else {
        emit(UserError(
            message: 'Gagal memuat data. Status: ${response.statusCode}'));
      }
    } catch (e) {
      // ---------------------------------------------------------------------
      // 🔄 PERUBAHAN:
      // Dulu: setState(() { errorMessage = e.toString(); isLoading = false; });
      // Sekarang: emit(UserError(message: e.toString()));
      // ---------------------------------------------------------------------
      emit(UserError(message: 'Terjadi kesalahan: $e'));
    }
  }

  // =========================================================================
  // METHOD TAMBAHAN (tidak ada di Pertemuan 1)
  // =========================================================================

  /// Method untuk refresh data
  Future<void> refreshUsers() async {
    await loadUsers();
  }
}
