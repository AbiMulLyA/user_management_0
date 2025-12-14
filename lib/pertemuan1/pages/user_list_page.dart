// ============================================================================
// PERTEMUAN 1: HALAMAN LIST USER - SEMUA LOGIC DI SINI
// ============================================================================
//
// ⚠️ PERHATIAN: Kode ini SENGAJA dibuat "tidak ideal"!
//
// Di file ini, SEMUA logic digabung jadi satu:
// - UI (tampilan)
// - Business Logic (pengolahan data)
// - Data Access (HTTP request ke API)
//
// MASALAH DENGAN PENDEKATAN INI:
// 1. File menjadi sangat panjang dan sulit dibaca
// 2. Sulit untuk di-test (harus test UI + Logic + API sekaligus)
// 3. Sulit untuk diubah (mengubah 1 hal bisa merusak yang lain)
// 4. Tidak bisa reuse logic di halaman lain
//
// Di pertemuan selanjutnya, kita akan REFACTOR kode ini menggunakan
// Clean Architecture untuk mengatasi masalah-masalah di atas.
//
// ============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// Halaman untuk menampilkan list user
///
/// StatefulWidget digunakan karena:
/// - Ada data yang berubah (list users, loading state, error state)
/// - Perlu memanggil API saat halaman dibuka
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // =========================================================================
  // STATE VARIABLES
  // =========================================================================
  // Di sini kita simpan semua "kondisi" halaman
  // =========================================================================

  /// List user yang didapat dari API
  List<UserModel> users = [];

  /// Apakah sedang loading data?
  bool isLoading = false;

  /// Pesan error jika terjadi kesalahan
  String? errorMessage;

  // =========================================================================
  // LIFECYCLE METHODS
  // =========================================================================

  /// initState dipanggil sekali saat widget pertama kali dibuat
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data saat halaman dibuka
    fetchUsers();
  }

  // =========================================================================
  // FUNGSI UNTUK FETCH DATA DARI API
  // =========================================================================
  //
  // ⚠️ MASALAH: Logic API ada di dalam UI widget!
  //
  // Ini membuat:
  // - Sulit testing (harus mock HTTP di widget test)
  // - Tidak bisa reuse di halaman lain
  // - Campur aduk antara UI dan logic
  //
  // =========================================================================

  /// Mengambil data user dari API
  ///
  /// Fungsi ini melakukan:
  /// 1. Set loading state ke true
  /// 2. Panggil API
  /// 3. Parse response JSON
  /// 4. Update state dengan data atau error
  Future<void> fetchUsers() async {
    // ---------------------------------------------------------------------
    // LANGKAH 1: Mulai loading
    // ---------------------------------------------------------------------
    // setState() memberitahu Flutter untuk rebuild UI
    // karena ada perubahan state
    // ---------------------------------------------------------------------
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // -------------------------------------------------------------------
      // LANGKAH 2: Kirim HTTP GET request
      // -------------------------------------------------------------------
      // ⚠️ URL API di-hardcode di sini! Tidak ideal.
      // Seharusnya ada di file config terpisah.
      // -------------------------------------------------------------------
      final response = await http.get(
        Uri.parse(
            'https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate/user'),
        headers: {'Content-Type': 'application/json'},
      );

      // -------------------------------------------------------------------
      // LANGKAH 3: Cek status response
      // -------------------------------------------------------------------
      if (response.statusCode == 200) {
        // -----------------------------------------------------------------
        // LANGKAH 4: Parse JSON menjadi List<UserModel>
        // -----------------------------------------------------------------
        // json.decode() mengkonversi string JSON menjadi object Dart
        // Hasilnya adalah List<dynamic> karena response berupa array
        // -----------------------------------------------------------------
        final List<dynamic> jsonList = json.decode(response.body);

        // Konversi setiap item JSON menjadi UserModel
        final List<UserModel> fetchedUsers =
            jsonList.map((json) => UserModel.fromJson(json)).toList();

        // Update state dengan data baru
        setState(() {
          users = fetchedUsers;
          isLoading = false;
        });
      } else {
        // Response tidak sukses
        setState(() {
          errorMessage = 'Gagal memuat data. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      // -------------------------------------------------------------------
      // Error handling: network error, parsing error, dll
      // -------------------------------------------------------------------
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  // =========================================================================
  // BUILD METHOD - UI
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------------------------------------------------------------------
      // APP BAR
      // -------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Daftar User'),
        centerTitle: true,
        actions: [
          // Tombol refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
            tooltip: 'Refresh',
          ),
        ],
      ),

      // -------------------------------------------------------------------
      // BODY - Tampilkan berdasarkan state
      // -------------------------------------------------------------------
      body: _buildBody(),
    );
  }

  /// Widget builder untuk body berdasarkan state
  ///
  /// Menggunakan conditional untuk menampilkan:
  /// - Loading indicator jika sedang loading
  /// - Error message jika ada error
  /// - List user jika data berhasil dimuat
  Widget _buildBody() {
    // ---------------------------------------------------------------------
    // STATE: Loading
    // ---------------------------------------------------------------------
    if (isLoading) {
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

    // ---------------------------------------------------------------------
    // STATE: Error
    // ---------------------------------------------------------------------
    if (errorMessage != null) {
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
              'Oops! Terjadi Kesalahan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: fetchUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------------------
    // STATE: Empty (tidak ada data)
    // ---------------------------------------------------------------------
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data user',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------------------
    // STATE: Success (tampilkan data)
    // ---------------------------------------------------------------------
    return RefreshIndicator(
      onRefresh: fetchUsers,
      child: Column(
        children: [
          // Info jumlah user
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Total: ${users.length} user',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // List user
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan satu user dalam bentuk card
  ///
  /// ⚠️ MASALAH: Widget ini di-define di dalam page!
  /// Seharusnya bisa di-extract ke file terpisah agar reusable.
  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan avatar dan nama
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

            // Detail info
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

  /// Helper widget untuk menampilkan satu baris info
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
