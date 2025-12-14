// ============================================================================
// FILE: user_list_page.dart
// DESKRIPSI: Halaman utama untuk menampilkan daftar user
// LOKASI: lib/features/user/presentation/pages/
// ============================================================================
//
// PAGE adalah widget yang merepresentasikan satu layar penuh.
// Page biasanya terdiri dari Scaffold dengan AppBar dan Body.
//
// STRUKTUR PAGE INI:
// -------------------------------------------------------------------------
// ┌──────────────────────────────────────┐
// │  AppBar (User Management)            │
// ├──────────────────────────────────────┤
// │  Search Bar                          │
// ├──────────────────────────────────────┤
// │  City Filter Dropdown                │
// ├──────────────────────────────────────┤
// │  Info: "Menampilkan X user"          │
// ├──────────────────────────────────────┤
// │                                      │
// │  ListView                            │
// │  ┌──────────────────────────────┐   │
// │  │ UserCard 1                    │   │
// │  └──────────────────────────────┘   │
// │  ┌──────────────────────────────┐   │
// │  │ UserCard 2                    │   │
// │  └──────────────────────────────┘   │
// │  ...                                 │
// │                                      │
// ├──────────────────────────────────────┤
// │                         [FAB +]      │ <- Floating Action Button
// └──────────────────────────────────────┘
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';
import '../widgets/user_card.dart';
import '../widgets/user_search_bar.dart';
import '../widgets/city_filter_dropdown.dart';
import 'add_user_page.dart';

/// Halaman utama untuk menampilkan list user
///
/// STATEFUL WIDGET karena:
/// - Perlu initState() untuk load data saat pertama kali
/// - Ada lifecycle methods yang dibutuhkan
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

/// State class untuk UserListPage
///
/// Nama konvensi: _[WidgetName]State dengan underscore (private)
class _UserListPageState extends State<UserListPage> {
  // -------------------------------------------------------------------------
  // LIFECYCLE: initState
  // -------------------------------------------------------------------------

  /// Dipanggil sekali saat widget pertama kali dibuat
  ///
  /// Digunakan untuk:
  /// - Load data awal
  /// - Setup listener
  /// - Inisialisasi controller
  @override
  void initState() {
    super.initState();

    // -----------------------------------------------------------------------
    // LOAD DATA SAAT HALAMAN DIBUKA
    // -----------------------------------------------------------------------
    // context.read<UserCubit>() mengakses UserCubit dari BlocProvider
    // loadData() akan fetch data dari API dan update state
    // -----------------------------------------------------------------------
    context.read<UserCubit>().loadData();
  }

  // -------------------------------------------------------------------------
  // BUILD METHOD
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah struktur dasar halaman Material Design
    return Scaffold(
      // ---------------------------------------------------------------------
      // APP BAR
      // ---------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('User Management'),
        centerTitle: true,
        elevation: 2,
      ),

      // ---------------------------------------------------------------------
      // BODY dengan BlocBuilder
      // ---------------------------------------------------------------------
      // BlocBuilder me-rebuild widget saat state berubah
      // builder dipanggil setiap kali Cubit emit state baru
      // ---------------------------------------------------------------------
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // -----------------------------------------------------------------
          // STATE: Loading
          // -----------------------------------------------------------------
          // Tampilkan loading indicator saat sedang fetch data
          // -----------------------------------------------------------------
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // -----------------------------------------------------------------
          // STATE: Error
          // -----------------------------------------------------------------
          // Tampilkan pesan error dengan tombol retry
          // -----------------------------------------------------------------
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon error besar
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),

                  // Judul error
                  Text(
                    'Terjadi kesalahan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  // Pesan error detail
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Tombol retry
                  ElevatedButton(
                    onPressed: () {
                      // Coba load data lagi
                      context.read<UserCubit>().loadData();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // -----------------------------------------------------------------
          // STATE: Loaded
          // -----------------------------------------------------------------
          // Tampilkan data user dengan search, filter, dan list
          // -----------------------------------------------------------------
          if (state is UserLoaded) {
            // RefreshIndicator untuk pull-to-refresh
            return RefreshIndicator(
              // Callback saat user pull-to-refresh
              onRefresh: () async {
                await context.read<UserCubit>().loadData();
              },

              // Konten utama dalam Column
              child: Column(
                children: [
                  // -------------------------------------------------------
                  // WIDGET 1: Search Bar
                  // -------------------------------------------------------
                  UserSearchBar(
                    searchQuery: state.searchQuery,
                    onChanged: (query) {
                      // Panggil cubit untuk filter berdasarkan query
                      context.read<UserCubit>().searchUsers(query);
                    },
                  ),

                  // -------------------------------------------------------
                  // WIDGET 2: City Filter Dropdown
                  // -------------------------------------------------------
                  CityFilterDropdown(
                    cities: state.cities,
                    selectedCity: state.selectedCity,
                    onChanged: (city) {
                      // Panggil cubit untuk filter berdasarkan kota
                      context.read<UserCubit>().filterByCity(city);
                    },
                  ),

                  const SizedBox(height: 8),

                  // -------------------------------------------------------
                  // WIDGET 3: Info Jumlah User
                  // -------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Menampilkan ${state.filteredUsers.length} user',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // -------------------------------------------------------
                  // WIDGET 4: List User atau Empty State
                  // -------------------------------------------------------
                  // Expanded agar ListView mengisi ruang yang tersisa
                  // -------------------------------------------------------
                  Expanded(
                    child: state.filteredUsers.isEmpty
                        // Empty state jika tidak ada user
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada user ditemukan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        // ListView dengan data user
                        : ListView.builder(
                            // Jumlah item dalam list
                            itemCount: state.filteredUsers.length,

                            // Builder dipanggil untuk setiap item
                            // Lebih efisien daripada ListView(children: [...])
                            // karena hanya render item yang terlihat
                            itemBuilder: (context, index) {
                              final user = state.filteredUsers[index];
                              return UserCard(user: user);
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          // Default: widget kosong jika state tidak dikenali
          return const SizedBox.shrink();
        },
      ),

      // ---------------------------------------------------------------------
      // FLOATING ACTION BUTTON
      // ---------------------------------------------------------------------
      // FAB adalah tombol melayang di pojok kanan bawah
      // Digunakan untuk aksi utama (dalam kasus ini: tambah user)
      // ---------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // -----------------------------------------------------------------
          // NAVIGASI KE HALAMAN TAMBAH USER
          // -----------------------------------------------------------------
          // PENTING: Ambil cubit dari context yang benar SEBELUM navigasi
          // Context di dalam MaterialPageRoute adalah context berbeda
          // yang tidak memiliki akses ke BlocProvider
          // -----------------------------------------------------------------
          final cubit = context.read<UserCubit>();

          // Navigator.push untuk navigasi ke halaman baru
          // await karena kita ingin tahu hasilnya saat kembali
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              // Underscore (_) karena kita tidak pakai context builder
              builder: (_) => AddUserPage(
                cubit: cubit,
              ),
            ),
          );

          // -----------------------------------------------------------------
          // REFRESH SETELAH KEMBALI
          // -----------------------------------------------------------------
          // Jika result == true, artinya user berhasil ditambahkan
          // Refresh data untuk menampilkan user baru
          // -----------------------------------------------------------------
          if (result == true) {
            // mounted check untuk memastikan widget masih ada
            if (!context.mounted) return;
            context.read<UserCubit>().loadData();
          }
        },
        tooltip: 'Tambah User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
