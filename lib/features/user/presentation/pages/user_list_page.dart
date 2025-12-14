import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';
import '../widgets/user_card.dart';
import '../widgets/user_search_bar.dart';
import '../widgets/city_filter_dropdown.dart';
import 'add_user_page.dart';

/// Halaman utama untuk menampilkan list user
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    // Load data ketika page pertama kali dibuka
    context.read<UserCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        centerTitle: true,
        elevation: 2,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // State Loading
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // State Error
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserCubit>().loadData();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // State Loaded
          if (state is UserLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<UserCubit>().loadData();
              },
              child: Column(
                children: [
                  // Search Bar
                  UserSearchBar(
                    searchQuery: state.searchQuery,
                    onChanged: (query) {
                      context.read<UserCubit>().searchUsers(query);
                    },
                  ),

                  // City Filter Dropdown
                  CityFilterDropdown(
                    cities: state.cities,
                    selectedCity: state.selectedCity,
                    onChanged: (city) {
                      context.read<UserCubit>().filterByCity(city);
                    },
                  ),

                  const SizedBox(height: 8),

                  // Info jumlah user
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

                  // List User
                  Expanded(
                    child: state.filteredUsers.isEmpty
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
                        : ListView.builder(
                            itemCount: state.filteredUsers.length,
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

          return const SizedBox.shrink();
        },
      ),
      // Floating Action Button untuk tambah user
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ambil cubit dari context yang benar sebelum navigasi
          final cubit = context.read<UserCubit>();

          // Navigate ke halaman tambah user
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddUserPage(
                cubit: cubit,
              ),
            ),
          );

          // Refresh jika berhasil menambahkan user
          if (result == true) {
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
