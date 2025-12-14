// ============================================================================
// PERTEMUAN 1: FLUTTER BASIC - TANPA CLEAN ARCHITECTURE
// ============================================================================
//
// Pada pertemuan ini, kita akan membuat aplikasi sederhana:
// - Fetch data dari API
// - Tampilkan dalam list
//
// CATATAN PENTING:
// Kode ini SENGAJA dibuat "tidak rapi" untuk menunjukkan masalah yang akan
// muncul jika tidak menggunakan arsitektur yang baik:
// 1. Semua logic ada di UI (tidak terpisah)
// 2. Sulit untuk testing
// 3. Sulit untuk maintenance jika aplikasi membesar
//
// Di pertemuan selanjutnya, kita akan refactor kode ini menggunakan
// Clean Architecture.
//
// ============================================================================

import 'package:flutter/material.dart';
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
      title: 'User Management - Pertemuan 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        // Kustomisasi AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const UserListPage(),
    );
  }
}
