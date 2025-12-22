// ============================================================================
// PERTEMUAN 2: USER LIST PAGE - SEKARANG HANYA UI
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 1:
// ============================================================================
// Di Pertemuan 1, file ini berisi SEMUA: UI + State + Logic + HTTP
// Sekarang di Pertemuan 2, file ini HANYA berisi UI
//
// Yang DIPINDAHKAN:
// - State variables    → bloc/user_state.dart
// - fetchUsers()       → bloc/user_cubit.dart
// - setState()         → diganti dengan emit() di Cubit
// - StatefulWidget     → sekarang StatelessWidget
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';
import '../models/user_model.dart';

/// Halaman untuk menampilkan list user
///
/// 🔄 PERUBAHAN: Dulu StatefulWidget, sekarang StatelessWidget
/// Karena state dikelola oleh Cubit, bukan oleh widget ini.
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  // =========================================================================
  // 📌 JEJAK PERTEMUAN 1 - STATE VARIABLES (SUDAH DIPINDAHKAN)
  // =========================================================================
  // Kode di bawah ini DULU ada di sini (Pertemuan 1).
  // Sekarang DIPINDAHKAN ke: bloc/user_state.dart
  // =========================================================================
  //
  // List<UserModel> users = [];      // → Sekarang di UserLoaded.users
  // bool isLoading = false;          // → Sekarang jadi class UserLoading
  // String? errorMessage;            // → Sekarang di UserError.message
  //
  // =========================================================================

  // =========================================================================
  // 📌 JEJAK PERTEMUAN 1 - FETCH USERS (SUDAH DIPINDAHKAN)
  // =========================================================================
  // Method fetchUsers() DULU ada di sini (Pertemuan 1).
  // Sekarang DIPINDAHKAN ke: bloc/user_cubit.dart → method loadUsers()
  // =========================================================================
  //
  // Future<void> fetchUsers() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = null;
  //   });
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://627e360ab75a25d3f3b37d5a.mockapi.io/...'),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonList = json.decode(response.body);
  //       setState(() {
  //         users = jsonList.map((json) => UserModel.fromJson(json)).toList();
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = e.toString();
  //       isLoading = false;
  //     });
  //   }
  // }
  //
  // 🆕 SEKARANG: Cukup panggil context.read<UserCubit>().loadUsers()
  //
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // 🔄 PERUBAHAN: Dulu panggil fetchUsers(), sekarang via Cubit
            onPressed: () => context.read<UserCubit>().refreshUsers(),
            tooltip: 'Refresh',
          ),
        ],
      ),

      // =====================================================================
      // 🆕 BARU DI PERTEMUAN 2: BlocBuilder
      // =====================================================================
      // Dulu di Pertemuan 1 kita pakai if-else dengan isLoading, errorMessage
      // Sekarang pakai BlocBuilder yang reaktif terhadap state changes
      // =====================================================================
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          // -------------------------------------------------------------------
          // 📌 JEJAK PERTEMUAN 1: Dulu pakai if (isLoading) {...}
          // Sekarang pakai pattern matching: if (state is UserLoading)
          // -------------------------------------------------------------------

          if (state is UserInitial) {
            // Trigger load saat pertama kali
            context.read<UserCubit>().loadUsers();
            return const Center(child: CircularProgressIndicator());
          }

          // 🔄 Dulu: if (isLoading) return CircularProgressIndicator()
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

          // 🔄 Dulu: if (errorMessage != null) return ErrorWidget()
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
                      state.message, // 🔄 Dulu: errorMessage
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

          // 🔄 Dulu: langsung pakai variable 'users'
          // Sekarang: ambil dari state.users
          if (state is UserLoaded) {
            final users = state.users; // 🔄 Dulu: this.users

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

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Widget untuk menampilkan satu user dalam bentuk card
  /// (Sama seperti Pertemuan 1, belum dipisah ke file terpisah)
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

// =============================================================================
// =============================================================================
//
//                    🆚 VERSI ALTERNATIF: BLOCCONSUMER
//
// =============================================================================
// =============================================================================
//
// Di bawah ini adalah versi ALTERNATIF menggunakan BlocConsumer
// (kombinasi BlocBuilder + BlocListener)
//
// Untuk menggunakannya, ganti UserListPage dengan UserListPageConsumer di main.dart
//
// =============================================================================

// =============================================================================
// PENJELASAN BLOCBUILDER VS BLOCLISTENER - DENGAN ANALOGI 🎓
// =============================================================================
//
// 🤔 APA BEDANYA?
// ----------------
//
// 🏗️ BlocBuilder = KOKI di Restoran
// ----------------------------------
// - Tugasnya: MEMASAK (membangun UI) setiap kali pesanan berubah
// - Hasil: Makanan (Widget) yang ditampilkan ke pelanggan
// - Dipanggil: SETIAP kali state berubah dan perlu rebuild
//
// Contoh penggunaan:
// - Menampilkan daftar user (ListView)
// - Menampilkan loading spinner
// - Menampilkan pesan error di layar
//
//
// 👂 BlocListener = PELAYAN yang Teriak "PESANAN SIAP!"
// -----------------------------------------------------
// - Tugasnya: MENDENGARKAN dan melakukan AKSI SEKALI
// - Hasil: Tidak ada (void) - hanya aksi
// - Dipanggil: SEKALI setiap state berubah (tidak rebuild ulang)
//
// Contoh penggunaan:
// - Menampilkan SnackBar (notifikasi sementara)
// - Navigasi ke halaman lain
// - Menampilkan Dialog popup
// - Play sound effect
//
//
// 🎭 ANALOGI LENGKAP: RESTORAN
// ----------------------------
//
// BlocBuilder (KOKI):
//   Pesanan: "Nasi Goreng" → Koki masak Nasi Goreng 🍛
//   Pesanan berubah: "Mie Goreng" → Koki masak ulang jadi Mie Goreng 🍜
//   → Setiap perubahan = masak ulang (rebuild UI)
//
// BlocListener (PELAYAN):
//   Masakan selesai → Pelayan teriak "PESANAN SIAP!" 📢
//   → Cukup teriak sekali, tidak perlu teriak terus-menerus
//   → Aksi sekali sudah cukup (one-time action)
//
//
// 📊 TABEL PERBANDINGAN:
// ----------------------
// +------------------+-------------------+----------------------+
// | Aspek            | BlocBuilder       | BlocListener         |
// +------------------+-------------------+----------------------+
// | Return           | Widget            | void (tidak ada)     |
// | Frekuensi        | Setiap rebuild    | Sekali per perubahan |
// | Untuk            | Tampilan UI       | Side effects/aksi    |
// | Contoh           | ListView, Text    | SnackBar, Navigate   |
// +------------------+-------------------+----------------------+
//
//
// 🎯 BLOCCONSUMER = BLOCBUILDER + BLOCLISTENER
// ---------------------------------------------
// Seperti KOKI yang juga bisa TERIAK "pesanan siap!"
// - Dia memasak (build UI)
// - DAN dia juga bisa teriak (side effect)
//
// =============================================================================

/// 🆚 VERSI ALTERNATIF: Menggunakan BlocConsumer
///
/// Perbedaan dengan UserListPage (BlocBuilder):
/// - BlocBuilder: Hanya rebuild UI
/// - BlocConsumer: Rebuild UI + Side effects (SnackBar, Dialog, dll)
///
/// Untuk menggunakan versi ini, ganti di main.dart:
/// ```dart
/// // Dari:
/// home: UserListPage()
/// // Menjadi:
/// home: UserListPageConsumer()
/// ```
class UserListPageConsumer extends StatelessWidget {
  const UserListPageConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
        centerTitle: true,
        // Warna berbeda untuk membedakan dengan versi BlocBuilder
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserCubit>().refreshUsers(),
            tooltip: 'Refresh',
          ),
        ],
      ),

      // =====================================================================
      // 🆚 PERBANDINGAN: BlocBuilder vs BlocConsumer
      // =====================================================================
      //
      // VERSI BLOCBUILDER (di atas):
      // ```dart
      // body: BlocBuilder<UserCubit, UserState>(
      //   builder: (context, state) {
      //     // Hanya bisa return Widget
      //     // Tidak bisa tampilkan SnackBar di sini!
      //   },
      // ),
      // ```
      //
      // VERSI BLOCCONSUMER (di bawah):
      // ```dart
      // body: BlocConsumer<UserCubit, UserState>(
      //   listener: (context, state) {
      //     // Untuk side effects: SnackBar, Dialog, Navigate
      //   },
      //   builder: (context, state) {
      //     // Untuk return Widget
      //   },
      // ),
      // ```
      //
      // =====================================================================
      body: BlocConsumer<UserCubit, UserState>(
        // -------------------------------------------------------------------
        // 👂 LISTENER: Untuk SIDE EFFECTS (aksi sekali)
        // -------------------------------------------------------------------
        // 🎓 ANALOGI: Pelayan yang teriak "pesanan siap!"
        // Dipanggil SEKALI setiap state berubah
        //
        // ❓ KAPAN PAKAI LISTENER?
        // - Menampilkan SnackBar
        // - Menampilkan Dialog
        // - Navigasi ke halaman lain
        // - Analytics/Logging
        // - Play sound
        // -------------------------------------------------------------------
        listener: (context, state) {
          // ✅ SUKSES: Tampilkan SnackBar hijau
          if (state is UserLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Berhasil memuat ${state.users.length} user'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          // ❌ ERROR: Tampilkan Dialog popup
          if (state is UserError) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                icon: const Icon(Icons.error, color: Colors.red, size: 48),
                title: const Text('Terjadi Kesalahan'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<UserCubit>().loadUsers();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
        },

        // -------------------------------------------------------------------
        // 🏗️ BUILDER: Untuk MEMBANGUN UI (sama seperti BlocBuilder)
        // -------------------------------------------------------------------
        // 🎓 ANALOGI: Koki yang memasak UI
        // Dipanggil setiap kali perlu rebuild
        //
        // ❓ KAPAN PAKAI BUILDER?
        // - Menampilkan ListView
        // - Menampilkan loading indicator
        // - Menampilkan Text, Image, Card, dll
        // -------------------------------------------------------------------
        builder: (context, state) {
          // Trigger load saat pertama kali
          if (state is UserInitial) {
            context.read<UserCubit>().loadUsers();
            return const Center(child: CircularProgressIndicator());
          }

          // Loading state
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

          // Error state - Tampilkan UI error
          // (Dialog sudah ditampilkan di listener!)
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

          // Loaded state
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
                  // Header dengan badge "Consumer Version"
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal.shade50,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.teal),
                        SizedBox(width: 4),
                        Text(
                          'Versi BlocConsumer - Perhatikan SnackBar saat refresh!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
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

          return const SizedBox.shrink();
        },
      ),
    );
  }

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
                  backgroundColor: Colors.teal,
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

// =============================================================================
// 📚 RINGKASAN KAPAN MENGGUNAKAN APA
// =============================================================================
//
// ✅ Gunakan BlocBuilder (UserListPage) ketika:
//    - Kamu HANYA perlu menampilkan UI berdasarkan state
//    - Tidak perlu SnackBar, Dialog, atau Navigation
//
// ✅ Gunakan BlocConsumer (UserListPageConsumer) ketika:
//    - Kamu perlu KEDUANYA: rebuild UI + side effect
//    - Contoh: Tampilkan list user + SnackBar ketika sukses/error
//
// ✅ Gunakan BlocListener ketika:
//    - Kamu HANYA perlu side effect tanpa rebuild UI
//    - Biasanya di-wrap di atas BlocBuilder
//
// =============================================================================
