// ============================================================================
// FILE: city_filter_dropdown.dart
// DESKRIPSI: Widget dropdown untuk filter berdasarkan kota
// LOKASI: lib/features/user/presentation/widgets/
// ============================================================================
//
// Dropdown adalah komponen UI yang menampilkan pilihan dalam menu popup.
// User memilih satu opsi dari daftar yang tersedia.
//
// ============================================================================

import 'package:flutter/material.dart';
import '../../domain/entities/city_entity.dart';

/// Widget dropdown untuk filter berdasarkan kota
///
/// Menampilkan dropdown dengan:
/// - Opsi "Semua Kota" (value: null)
/// - Daftar kota dari API
///
/// PENGGUNAAN:
/// ```dart
/// CityFilterDropdown(
///   cities: listOfCities,
///   selectedCity: currentlySelectedCity,
///   onChanged: (city) {
///     // Handle selection
///   },
/// )
/// ```
class CityFilterDropdown extends StatelessWidget {
  // -------------------------------------------------------------------------
  // PROPERTIES
  // -------------------------------------------------------------------------

  /// Daftar kota yang akan ditampilkan sebagai opsi
  final List<CityEntity> cities;

  /// Kota yang sedang dipilih (null = "Semua Kota")
  final String? selectedCity;

  /// Callback saat user memilih kota
  /// Parameter bisa null jika user memilih "Semua Kota"
  final Function(String?) onChanged;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  const CityFilterDropdown({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
  });

  // -------------------------------------------------------------------------
  // BUILD METHOD
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Container dengan padding horizontal
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      // DropdownButtonFormField sudah include form decoration
      // Berbeda dengan DropdownButton biasa yang lebih basic
      child: DropdownButtonFormField<String>(
        // -----------------------------------------------------------------
        // INITIAL VALUE
        // -----------------------------------------------------------------
        // Value awal yang dipilih saat dropdown pertama kali ditampilkan
        // -----------------------------------------------------------------
        initialValue: selectedCity,

        // -----------------------------------------------------------------
        // DECORATION
        // -----------------------------------------------------------------
        decoration: InputDecoration(
          labelText: 'Filter berdasarkan kota',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),

        // -----------------------------------------------------------------
        // DROPDOWN ITEMS
        // -----------------------------------------------------------------
        // List items yang akan ditampilkan di dropdown menu
        // Setiap item adalah DropdownMenuItem<String>
        // -----------------------------------------------------------------
        items: [
          // ---------------------------------------------------------------
          // ITEM 1: Opsi "Semua Kota"
          // ---------------------------------------------------------------
          // Value null artinya tidak ada filter kota
          // ---------------------------------------------------------------
          const DropdownMenuItem<String>(
            value: null,
            child: Text('Semua Kota'),
          ),

          // ---------------------------------------------------------------
          // ITEM 2-N: Daftar kota dari API
          // ---------------------------------------------------------------
          // Spread operator (...) untuk menambahkan semua items ke list
          // .map() mengkonversi setiap CityEntity menjadi DropdownMenuItem
          // ---------------------------------------------------------------
          ...cities.map((city) => DropdownMenuItem<String>(
                value: city.name, // Value yang dikirim saat dipilih
                child: Text(city.name), // Text yang ditampilkan
              )),
        ],

        // -----------------------------------------------------------------
        // CALLBACK onChanged
        // -----------------------------------------------------------------
        // Dipanggil saat user memilih item dari dropdown
        // Parameter adalah value dari item yang dipilih
        // -----------------------------------------------------------------
        onChanged: onChanged,
      ),
    );
  }
}
