// ============================================================================
// PERTEMUAN 2: MENAMBAHKAN STATE MANAGEMENT DENGAN CUBIT
// ============================================================================
//
// Pada pertemuan ini, kita mulai memisahkan:
// - STATE MANAGEMENT (logic) dari UI
//
// PERBEDAAN DARI PERTEMUAN 1:
// -------------------------------------------------------------------------
// Pertemuan 1: Semua logic di dalam Page (StatefulWidget)
// Pertemuan 2: Logic dipindahkan ke Cubit, Page hanya untuk UI
//
// KEUNTUNGAN:
// 1. UI lebih bersih (hanya fokus tampilan)
// 2. Logic bisa di-test terpisah
// 3. State bisa di-share antar halaman
//
// MASIH BELUM IDEAL:
// - HTTP request masih di dalam Cubit
// - Belum ada Repository pattern
// - Akan diperbaiki di Pertemuan 3
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
      // -----------------------------------------------------------------------
      // BLOCPROVIDER
      // -----------------------------------------------------------------------
      // BlocProvider menyediakan Cubit ke seluruh widget tree di bawahnya.
      // Semua widget child bisa mengakses UserCubit melalui:
      // - context.read<UserCubit>()  -> untuk memanggil method
      // - context.watch<UserCubit>() -> untuk listen changes
      // - BlocBuilder -> untuk rebuild UI saat state berubah
      // -----------------------------------------------------------------------
      home: BlocProvider(
        // create: callback untuk membuat instance Cubit
        create: (context) => UserCubit(),
        child: const UserListPage(),
      ),
    );
  }
}
