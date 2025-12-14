// ============================================================================
// PERTEMUAN 2: MENAMBAHKAN STATE MANAGEMENT DENGAN CUBIT
// ============================================================================
//
// 🔄 PERUBAHAN DARI PERTEMUAN 1:
// ============================================================================
// Di Pertemuan 1, main.dart sangat sederhana - langsung ke Page.
// Di Pertemuan 2, kita menambahkan BlocProvider untuk menyediakan Cubit.
//
// YANG BARU:
// - import flutter_bloc
// - BlocProvider wrapper
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/user_cubit.dart';
import 'pages/user_list_page.dart';

/// Entry point aplikasi
void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management - Pertemuan 2',
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
      // 🆕 BARU DI PERTEMUAN 2: BlocProvider
      // =====================================================================
      //
      // 📌 JEJAK PERTEMUAN 1:
      // Dulu langsung: home: const UserListPage()
      //
      // Sekarang dibungkus dengan BlocProvider:
      // - BlocProvider membuat instance UserCubit
      // - UserCubit bisa diakses dari semua widget di bawahnya
      // - Menggunakan context.read<UserCubit>() atau BlocBuilder
      //
      // =====================================================================
      home: BlocProvider(
        // create: callback untuk membuat instance Cubit
        // 🆕 Di sini Cubit dibuat, bukan di dalam Page seperti dulu
        create: (context) => UserCubit(),
        child: const UserListPage(),
      ),
      // =====================================================================
      // 📌 PERBANDINGAN:
      // Pertemuan 1: home: const UserListPage()
      // Pertemuan 2: home: BlocProvider(create: ..., child: UserListPage())
      // =====================================================================
    );
  }
}
