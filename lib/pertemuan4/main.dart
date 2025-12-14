// ============================================================================
// PERTEMUAN 4: CLEAN ARCHITECTURE LENGKAP
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 3:
// ============================================================================
// Di Pertemuan 3, DI dilakukan manual di main():
//   final httpClient = http.Client();
//   final dataSource = ...
//   final repository = ...
//   final cubit = ...
//
// Di Pertemuan 4, DI DIPINDAHKAN ke Injector class:
//   Injector().init();
//
// main.dart sekarang sangat bersih dan fokus!
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/injector.dart';
import 'features/user/presentation/pages/user_list_page.dart';

/// Entry point aplikasi
void main() {
  // =========================================================================
  // 📌 JEJAK PERTEMUAN 3: DI dipindahkan ke Injector
  // =========================================================================
  //
  // KODE LAMA (Pertemuan 3):
  // -----------------------------------------------------------------
  // void main() {
  //   final httpClient = http.Client();
  //   final userDataSource = UserRemoteDataSourceImpl(client: httpClient);
  //   final userRepository = UserRepositoryImpl(dataSource: userDataSource);
  //   final userCubit = UserCubit(repository: userRepository);
  //   runApp(MyApp(userCubit: userCubit));
  // }
  //
  // SEKARANG (Pertemuan 4):
  // Semua sudah di-handle oleh Injector. Main tinggal panggil init().
  // =========================================================================
  Injector().init();

  runApp(const MyApp());
}

/// Root widget aplikasi
///
/// 🔄 PERUBAHAN:
/// Pertemuan 3: MyApp menerima userCubit dari constructor
/// Pertemuan 4: MyApp mengambil userCubit dari Injector
class MyApp extends StatelessWidget {
  // =========================================================================
  // 📌 PERHATIKAN: Tidak ada constructor parameter!
  // =========================================================================
  // Di Pertemuan 3: const MyApp({required this.userCubit})
  // Di Pertemuan 4: const MyApp() - cubit diambil dari Injector
  // =========================================================================
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management - Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: BlocProvider(
        // =====================================================================
        // 🔄 PERUBAHAN:
        // Pertemuan 3: BlocProvider.value(value: userCubit, ...)
        // Pertemuan 4: BlocProvider(create: (_) => Injector().userCubit, ...)
        //
        // Cubit diambil dari Injector singleton, bukan dari constructor
        // =====================================================================
        create: (context) => Injector().userCubit,
        child: const UserListPage(),
      ),
    );
  }
}
