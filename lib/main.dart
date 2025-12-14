// ============================================================================
// FILE: main.dart
// DESKRIPSI: Entry point utama aplikasi Flutter
// ============================================================================
//
// File ini adalah titik masuk (entry point) aplikasi Flutter.
// Di sini kita melakukan:
// 1. Inisialisasi Dependency Injection
// 2. Menjalankan aplikasi dengan runApp()
// 3. Mengkonfigurasi tema dan routing
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/injector/injector.dart';
import 'features/user/presentation/pages/user_list_page.dart';

/// Fungsi main() adalah entry point aplikasi Flutter
/// Semua aplikasi Flutter dimulai dari fungsi ini
void main() {
  // -------------------------------------------------------------------------
  // LANGKAH 1: Inisialisasi Dependency Injection
  // -------------------------------------------------------------------------
  // Sebelum menjalankan aplikasi, kita perlu menyiapkan semua dependencies
  // yang dibutuhkan oleh aplikasi. Ini dilakukan melalui class Injector.
  //
  // Dependency Injection adalah teknik dimana object menerima dependencies-nya
  // dari luar, bukan membuat sendiri di dalamnya.
  // -------------------------------------------------------------------------
  Injector().init();

  // -------------------------------------------------------------------------
  // LANGKAH 2: Menjalankan Aplikasi
  // -------------------------------------------------------------------------
  // runApp() adalah fungsi dari Flutter yang menjalankan widget tree
  // Widget yang diberikan ke runApp() akan menjadi root dari widget tree
  // -------------------------------------------------------------------------
  runApp(const MyApp());
}

/// MyApp adalah root widget dari aplikasi
/// Widget ini mengkonfigurasi MaterialApp dengan tema dan halaman utama
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // MaterialApp adalah widget yang menyediakan banyak fitur built-in:
    // - Navigation (Navigator)
    // - Theme (warna, font, style)
    // - Localization
    // - dan lainnya
    // -------------------------------------------------------------------------
    return MaterialApp(
      // Judul aplikasi (muncul di task switcher)
      title: 'User Management App',

      // Menghilangkan banner "DEBUG" di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // -----------------------------------------------------------------------
      // KONFIGURASI TEMA
      // -----------------------------------------------------------------------
      // ThemeData mengatur tampilan visual aplikasi secara global
      // Semua widget child akan inherit style dari tema ini
      // -----------------------------------------------------------------------
      theme: ThemeData(
        // Warna utama aplikasi
        primarySwatch: Colors.blue,

        // Menggunakan Material Design 3 (versi terbaru)
        useMaterial3: true,

        // Kustomisasi AppBar (header di bagian atas halaman)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Warna background
          foregroundColor: Colors.white, // Warna text dan icon
          elevation: 2, // Bayangan di bawah AppBar
        ),

        // Kustomisasi tombol ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),

        // Kustomisasi TextField/Form input
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

      // -----------------------------------------------------------------------
      // HALAMAN UTAMA DENGAN BLOC PROVIDER
      // -----------------------------------------------------------------------
      // BlocProvider menyediakan UserCubit ke widget tree
      // Semua widget child bisa mengakses UserCubit melalui context
      //
      // Ini adalah bagian dari pattern BLoC (Business Logic Component)
      // yang memisahkan UI dari business logic
      // -----------------------------------------------------------------------
      home: BlocProvider(
        // create: callback untuk membuat instance UserCubit
        // UserCubit diambil dari Injector (dependency injection)
        create: (context) => Injector().userCubit,

        // child: widget yang akan memiliki akses ke UserCubit
        child: const UserListPage(),
      ),
    );
  }
}
