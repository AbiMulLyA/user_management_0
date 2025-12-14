// ============================================================================
// PERTEMUAN 3: MENAMBAHKAN DATA LAYER (REPOSITORY & DATASOURCE)
// ============================================================================
//
// Pada pertemuan ini, kita menambahkan DATA LAYER:
// - Repository: Abstraksi akses data
// - DataSource: Implementasi akses ke API
// - Model dengan toJson untuk POST
//
// PERBEDAAN DARI PERTEMUAN 2:
// -------------------------------------------------------------------------
// Pertemuan 2: Cubit langsung panggil HTTP/API
// Pertemuan 3: Cubit -> Repository -> DataSource -> API
//
// KEUNTUNGAN:
// 1. Cubit tidak perlu tahu tentang HTTP
// 2. Repository bisa di-mock untuk testing
// 3. Mudah ganti sumber data (API, local DB, dll)
//
// MASIH BELUM IDEAL:
// - Belum ada Entity (masih pakai Model langsung)
// - Belum ada Use Cases
// - Dependency masih dibuat langsung
// - Akan diperbaiki di Pertemuan 4 (Clean Architecture lengkap)
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
  // -------------------------------------------------------------------------
  // MEMBUAT DEPENDENCIES SECARA MANUAL
  // -------------------------------------------------------------------------
  // Di sini kita membuat semua dependencies secara urut:
  // 1. HTTP Client
  // 2. DataSource (butuh Client)
  // 3. Repository (butuh DataSource)
  // 4. Cubit (butuh Repository)
  //
  // ⚠️ Masih manual! Di Pertemuan 4, kita akan pakai Dependency Injection
  // -------------------------------------------------------------------------

  // LANGKAH 1: Buat HTTP Client
  final httpClient = http.Client();

  // LANGKAH 2: Buat Data Source
  final userDataSource = UserRemoteDataSourceImpl(client: httpClient);

  // LANGKAH 3: Buat Repository
  final userRepository = UserRepositoryImpl(dataSource: userDataSource);

  // LANGKAH 4: Buat Cubit
  final userCubit = UserCubit(repository: userRepository);

  runApp(MyApp(userCubit: userCubit));
}

/// Root widget aplikasi
class MyApp extends StatelessWidget {
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
      // BlocProvider.value karena Cubit sudah dibuat di luar
      home: BlocProvider.value(
        value: userCubit,
        child: const UserListPage(),
      ),
    );
  }
}
