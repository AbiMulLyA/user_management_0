// ============================================================================
// PERTEMUAN 2: USER LIST PAGE - UI DENGAN BLOCBUILDER
// ============================================================================
//
// PERBEDAAN DARI PERTEMUAN 1:
// -------------------------------------------------------------------------
// Pertemuan 1:
// - StatefulWidget dengan setState()
// - Logic (HTTP, state) di dalam page
// - UI dan Logic campur jadi satu
//
// Pertemuan 2:
// - StatelessWidget (karena state dikelola Cubit)
// - BlocBuilder untuk reaktif terhadap state
// - Page hanya fokus ke UI
// - Logic sudah dipindahkan ke UserCubit
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';
import '../models/user_model.dart';

/// Halaman untuk menampilkan list user
///
/// PERHATIKAN: Sekarang menggunakan StatelessWidget!
/// Karena state dikelola oleh Cubit, bukan oleh widget ini.
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ---------------------------------------------------------------
              // MEMANGGIL METHOD CUBIT
              // ---------------------------------------------------------------
              // context.read<UserCubit>() mengakses Cubit dari BlocProvider
              // Lalu panggil method refreshUsers()
              // ---------------------------------------------------------------
              context.read<UserCubit>().refreshUsers();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // BLOCBUILDER - REAKTIF TERHADAP STATE
      // -----------------------------------------------------------------------
      // BlocBuilder<CubitType, StateType> akan:
      // 1. Listen perubahan state dari Cubit
      // 2. Rebuild widget saat state berubah
      //
      // builder(context, state) dipanggil setiap kali state berubah
      // -----------------------------------------------------------------------
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // -----------------------------------------------------------------
          // LOAD DATA SAAT PERTAMA KALI
          // -----------------------------------------------------------------
          // Jika state masih Initial, panggil loadUsers()
          // -----------------------------------------------------------------
          if (state is UserInitial) {
            // Panggil loadUsers saat pertama kali
            context.read<UserCubit>().loadUsers();
            return const Center(child: CircularProgressIndicator());
          }

          // -----------------------------------------------------------------
          // STATE: Loading
          // -----------------------------------------------------------------
          if (state is UserLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data...'),
                ],
              ),
            );
          }

          // -----------------------------------------------------------------
          // STATE: Error
          // -----------------------------------------------------------------
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Terjadi Kesalahan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<UserCubit>().loadUsers(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // -----------------------------------------------------------------
          // STATE: Loaded
          // -----------------------------------------------------------------
          if (state is UserLoaded) {
            final users = state.users;

            if (users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada data user',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<UserCubit>().refreshUsers(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Total: ${users.length} user',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(users[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          // Default
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Widget untuk menampilkan satu user dalam bentuk card
  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email_outlined, 'Email', user.email),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone_outlined, 'Telepon', user.phoneNumber),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_city_outlined, 'Kota', user.city),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on_outlined, 'Alamat', user.address),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
