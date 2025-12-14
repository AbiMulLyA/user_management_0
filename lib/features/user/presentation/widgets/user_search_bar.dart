// ============================================================================
// FILE: user_search_bar.dart
// DESKRIPSI: Widget search bar untuk mencari user
// LOKASI: lib/features/user/presentation/widgets/
// ============================================================================
//
// Search bar adalah komponen UI yang memungkinkan user mencari data.
//
// CALLBACK PATTERN:
// Widget ini menerima callback function (onChanged) dari parent.
// Saat user mengetik, callback dipanggil dengan nilai terbaru.
// Ini memungkinkan parent mengontrol apa yang terjadi saat search.
//
// ============================================================================

import 'package:flutter/material.dart';

/// Widget search bar untuk mencari user
///
/// Widget stateless yang menerima:
/// - [onChanged]: Callback saat text berubah
/// - [searchQuery]: Query saat ini (untuk tampilkan clear button)
///
/// PENGGUNAAN:
/// ```dart
/// UserSearchBar(
///   searchQuery: currentQuery,
///   onChanged: (query) {
///     // Handle search
///   },
/// )
/// ```
class UserSearchBar extends StatelessWidget {
  // -------------------------------------------------------------------------
  // PROPERTIES
  // -------------------------------------------------------------------------

  /// Callback function yang dipanggil setiap kali text berubah
  /// Parameter: String query terbaru
  final Function(String) onChanged;

  /// Query pencarian saat ini
  /// Digunakan untuk menentukan apakah clear button ditampilkan
  final String searchQuery;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  const UserSearchBar({
    super.key,
    required this.onChanged,
    required this.searchQuery,
  });

  // -------------------------------------------------------------------------
  // BUILD METHOD
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Container untuk memberikan padding di sekitar TextField
    return Container(
      padding: const EdgeInsets.all(16),

      // TextField adalah widget untuk input text
      child: TextField(
        // -----------------------------------------------------------------
        // CALLBACK onChanged
        // -----------------------------------------------------------------
        // Dipanggil setiap kali user mengetik
        // Parameter adalah value terbaru di TextField
        // -----------------------------------------------------------------
        onChanged: onChanged,

        // -----------------------------------------------------------------
        // DECORATION: Mengatur tampilan TextField
        // -----------------------------------------------------------------
        decoration: InputDecoration(
          // Hint text (placeholder) saat field kosong
          hintText: 'Cari berdasarkan nama...',

          // Icon di sebelah kiri dalam TextField
          prefixIcon: const Icon(Icons.search),

          // -----------------------------------------------------------------
          // SUFFIX ICON: Clear button
          // -----------------------------------------------------------------
          // Hanya tampilkan jika ada text di search bar
          // Saat diklik, panggil onChanged('') untuk clear
          // -----------------------------------------------------------------
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  // Clear search dengan mengirim string kosong
                  onPressed: () => onChanged(''),
                )
              : null, // null = tidak tampilkan apa-apa

          // Border dengan rounded corners
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // Background color
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
