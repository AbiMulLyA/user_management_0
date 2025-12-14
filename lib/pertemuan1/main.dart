// ============================================================================
// PERTEMUAN 1: FLUTTER BASIC - TANPA CLEAN ARCHITECTURE
// ============================================================================
//
// Pada pertemuan ini, kita akan membuat aplikasi sederhana:
// - Fetch data dari API
// - Tampilkan dalam list
//
// Di pertemuan selanjutnya, kita akan refactor kode ini menggunakan
// Clean Architecture.
//
// ============================================================================

import 'package:flutter/material.dart';
import 'pages/user_list_page.dart';

// ============================================================================
// PENJELASAN KONSEP DASAR FLUTTER
// ============================================================================

// ----------------------------------------------------------------------------
// 1. FUNCTION void main()
// ----------------------------------------------------------------------------
// void main() adalah "entry point" atau titik masuk utama dari aplikasi Dart.
//
// Penjelasan:
// - "void" artinya function ini tidak mengembalikan nilai apapun
// - "main" adalah nama function khusus yang WAJIB ada di setiap aplikasi Dart
// - Ketika aplikasi dijalankan, Dart akan mencari function main() dan
//   menjalankan semua kode di dalamnya
//
// Analogi: Seperti pintu utama rumah - semua orang harus masuk lewat pintu ini
// ----------------------------------------------------------------------------
void main() {
  // --------------------------------------------------------------------------
  // 2. FUNCTION runApp()
  // --------------------------------------------------------------------------
  // runApp() adalah function bawaan Flutter yang berfungsi untuk:
  // - Menginisialisasi framework Flutter
  // - Menghubungkan widget tree dengan layar device
  // - Menjadikan widget yang diberikan sebagai root (akar) dari aplikasi
  //
  // Parameter: Widget yang akan menjadi root widget aplikasi
  //
  // Catatan: runApp() HANYA boleh dipanggil SEKALI dalam aplikasi
  // --------------------------------------------------------------------------
  runApp(const MyApp());
}

/// Root widget aplikasi
///
/// [StatelessWidget] adalah widget yang TIDAK memiliki state yang bisa berubah.
/// Cocok untuk widget yang tampilannya statis/tidak berubah-ubah.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // 3. MATERIALAPP WIDGET
    // ------------------------------------------------------------------------
    // MaterialApp adalah widget yang membungkus seluruh aplikasi dan
    // menyediakan fitur-fitur Material Design dari Google.
    //
    // Fungsi MaterialApp:
    // - Menyediakan tema (warna, font, dll) untuk seluruh aplikasi
    // - Mengatur navigasi dan routing antar halaman
    // - Menyediakan MediaQuery untuk mendapatkan info ukuran layar
    // - Menyediakan Directionality untuk arah teks (LTR/RTL)
    // - Menyediakan Localization untuk multi-bahasa
    //
    // Alternatif: CupertinoApp untuk iOS style, atau WidgetsApp untuk custom
    // ------------------------------------------------------------------------
    return MaterialApp(
      // Judul aplikasi (muncul di task manager/recent apps)
      title: 'User Management - Pertemuan 1',

      // ----------------------------------------------------------------------
      // 4. debugShowCheckedModeBanner
      // ----------------------------------------------------------------------
      // Properti ini mengontrol apakah banner "DEBUG" ditampilkan atau tidak.
      //
      // - true (default): Menampilkan banner "DEBUG" di pojok kanan atas
      // - false: Menyembunyikan banner tersebut
      //
      // Banner ini hanya muncul saat mode debug/development.
      // Biasanya diset false agar tampilan lebih bersih saat demo/presentasi.
      // Banner ini TIDAK akan muncul di production build (release mode).
      // ----------------------------------------------------------------------
      // debugShowCheckedModeBanner: false,

      // ----------------------------------------------------------------------
      // 5. THEMEDATA
      // ----------------------------------------------------------------------
      // ThemeData adalah class yang mendefinisikan tampilan visual aplikasi.
      // Dengan ThemeData, kita bisa mengatur:
      // - Warna primer, sekunder, dan aksen
      // - Style teks (headline, body, caption, dll)
      // - Style button, card, dialog, dll
      // - Dark mode atau light mode
      //
      // Keuntungan menggunakan ThemeData:
      // - Konsistensi tampilan di seluruh aplikasi
      // - Mudah mengubah tampilan dari satu tempat
      // - Mendukung dark/light mode dengan mudah
      // ----------------------------------------------------------------------
      theme: ThemeData(
        // primarySwatch: Palet warna utama yang akan digunakan di seluruh app
        // MaterialColor berisi 10 shade warna (50, 100, 200, ..., 900)
        primarySwatch: Colors.blue,

        // useMaterial3: Mengaktifkan Material Design 3 (terbaru)
        // Material 3 memiliki tampilan yang lebih modern dan rounded
        useMaterial3: true,

        // appBarTheme: Kustomisasi khusus untuk AppBar di seluruh aplikasi
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Warna background AppBar
          foregroundColor: Colors.white, // Warna teks dan icon di AppBar
          elevation: 2, // Tinggi bayangan (shadow) AppBar
        ),
      ),

      // home: Widget yang pertama kali ditampilkan saat aplikasi dibuka
      // Ini adalah "halaman utama" aplikasi
      home: const UserListPage(),
    );
  }
}
