// ============================================================================
// PERTEMUAN 3: MENAMBAHKAN DATA LAYER (REPOSITORY & DATASOURCE)
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 2:
// ============================================================================
// Di Pertemuan 2, Cubit dibuat langsung di BlocProvider.
// Di Pertemuan 3, kita membuat semua dependencies secara urut di main().
//
// YANG BARU:
// - Manual Dependency Injection
// - Urutan pembuatan: Client → DataSource → Repository → Cubit
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/user_repository.dart';
import 'bloc/user_cubit.dart';
import 'pages/user_list_page.dart';

/// Entry point aplikasi
void main() {
  // =========================================================================
  // 🆕 BARU DI PERTEMUAN 3: Manual Dependency Injection
  // =========================================================================
  //
  // 📌 JEJAK PERTEMUAN 2:
  // Dulu Cubit dibuat langsung di BlocProvider:
  //   create: (context) => UserCubit()
  //
  // Sekarang kita buat semua dependencies secara urut:
  //   1. HTTP Client
  //   2. DataSource (butuh Client)
  //   3. Repository (butuh DataSource)
  //   4. Cubit (butuh Repository)
  //
  // ⚠️ Urutan PENTING! Tidak boleh terbalik.
  // =========================================================================

  // LANGKAH 1: Buat HTTP Client
  final httpClient = http.Client();

  // LANGKAH 2: Buat Data Source (butuh Client)
  // 🆕 BARU: DataSource tidak ada di Pertemuan 2
  final userDataSource = UserRemoteDataSourceImpl(client: httpClient);

  // LANGKAH 3: Buat Repository (butuh DataSource)
  // 🆕 BARU: Repository tidak ada di Pertemuan 2
  final userRepository = UserRepositoryImpl(dataSource: userDataSource);

  // LANGKAH 4: Buat Cubit (butuh Repository)
  // 🔄 PERUBAHAN: Dulu UserCubit(), sekarang UserCubit(repository: ...)
  final userCubit = UserCubit(repository: userRepository);

  runApp(MyApp(userCubit: userCubit));
}

/// Root widget aplikasi
///
/// 🔄 PERUBAHAN: Sekarang menerima Cubit dari luar
class MyApp extends StatelessWidget {
  // 🆕 BARU: Cubit diterima dari constructor, bukan dibuat di dalam
  final UserCubit userCubit;

  const MyApp({super.key, required this.userCubit});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management - Pertemuan 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      // =====================================================================
      // 🔄 PERUBAHAN:
      // Pertemuan 2: BlocProvider(create: (context) => UserCubit(), ...)
      // Pertemuan 3: BlocProvider.value(value: userCubit, ...)
      //
      // Menggunakan .value karena Cubit sudah dibuat di luar
      // =====================================================================
      home: BlocProvider.value(
        value: userCubit,
        child: const UserListPage(),
      ),
    );
  }
}
