// ============================================================================
// PERTEMUAN 4: USER LIST PAGE - PRESENTATION LAYER
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
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        centerTitle: true,
        actions: [
          // Sort button
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return IconButton(
                  icon: Icon(
                    state.isAscending
                        ? Icons.sort_by_alpha
                        : Icons.sort_by_alpha_outlined,
                  ),
                  onPressed: () => context.read<UserCubit>().sortUsers(),
                  tooltip: state.isAscending ? 'Sort Z-A' : 'Sort A-Z',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserCubit>().loadData(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
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

          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(state.message, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<UserCubit>().loadData(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is UserLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<UserCubit>().loadData(),
              child: Column(
                children: [
                  // Search Bar (Widget terpisah)
                  UserSearchBar(
                    searchQuery: state.searchQuery,
                    onChanged: (query) {
                      context.read<UserCubit>().searchUsers(query);
                    },
                  ),

                  // City Filter Dropdown (Widget terpisah)
                  CityFilterDropdown(
                    cities: state.cities,
                    selectedCity: state.selectedCity,
                    onChanged: (city) {
                      context.read<UserCubit>().filterByCity(city);
                    },
                  ),

                  const SizedBox(height: 8),

                  // Info count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Menampilkan ${state.filteredUsers.length} dari ${state.users.length} user',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // List atau Empty state
                  Expanded(
                    child: state.filteredUsers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada user ditemukan',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = state.filteredUsers[index];
                              // UserCard (Widget terpisah)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cubit = context.read<UserCubit>();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddUserPage(cubit: cubit),
            ),
          );
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
