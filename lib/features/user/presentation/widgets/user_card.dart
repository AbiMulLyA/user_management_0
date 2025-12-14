// ============================================================================
// FILE: user_card.dart
// DESKRIPSI: Widget untuk menampilkan informasi user dalam bentuk card
// LOKASI: lib/features/user/presentation/widgets/
// ============================================================================
//
// WIDGET adalah building block dari UI Flutter.
// Semua yang terlihat di layar adalah Widget.
//
// STATELESS vs STATEFUL WIDGET:
// -------------------------------------------------------------------------
// STATELESS (UserCard):
// - Tidak memiliki state internal
// - Hanya menerima data dari parent dan menampilkannya
// - Cocok untuk UI yang tidak berubah sendiri
//
// STATEFUL:
// - Memiliki state internal yang bisa berubah
// - Bisa memanggil setState() untuk rebuild
// - Cocok untuk UI interaktif (form, animasi)
//
// REUSABLE WIDGET:
// UserCard adalah contoh widget yang reusable.
// Bisa digunakan berulang kali dengan data user yang berbeda.
//
// ============================================================================

import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';

/// Widget untuk menampilkan informasi user dalam bentuk card
///
/// Widget ini menerima UserEntity dan menampilkan:
/// - Avatar dengan inisial nama
/// - Nama lengkap
/// - Email, Telepon, Kota, Alamat
///
/// PENGGUNAAN:
/// ```dart
/// UserCard(user: userEntity)
/// ```
class UserCard extends StatelessWidget {
  // -------------------------------------------------------------------------
  // PROPERTY
  // -------------------------------------------------------------------------

  /// Data user yang akan ditampilkan
  /// 'final' karena widget Stateless tidak bisa diubah setelah dibuat
  final UserEntity user;

  // -------------------------------------------------------------------------
  // CONSTRUCTOR
  // -------------------------------------------------------------------------

  /// Constructor dengan required parameter user
  /// super.key adalah untuk widget identification (optimasi)
  const UserCard({
    super.key,
    required this.user,
  });

  // -------------------------------------------------------------------------
  // BUILD METHOD
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Card widget memberikan efek elevated box dengan shadow
    return Card(
      // Tinggi shadow di bawah card
      elevation: 2,

      // Margin di luar card
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // Shape untuk rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      // Padding dan konten di dalam card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // BAGIAN 1: Header dengan Avatar dan Nama
            // -----------------------------------------------------------------
            Row(
              children: [
                // Avatar berbentuk lingkaran dengan inisial nama
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    // Ambil huruf pertama dari nama dan jadikan uppercase
                    user.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Spasi horizontal
                const SizedBox(width: 12),

                // Nama user dengan Expanded agar tidak overflow
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Spasi vertikal
            const SizedBox(height: 12),

            // -----------------------------------------------------------------
            // BAGIAN 2: Informasi Detail User
            // -----------------------------------------------------------------
            // Menggunakan helper method _buildInfoRow untuk konsistensi

            // Email
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: user.email,
            ),
            const SizedBox(height: 8),

            // Phone
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: user.phoneNumber,
            ),
            const SizedBox(height: 8),

            // City
            _buildInfoRow(
              icon: Icons.location_city_outlined,
              label: 'City',
              value: user.city,
            ),
            const SizedBox(height: 8),

            // Address
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: user.address,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // HELPER METHOD
  // -------------------------------------------------------------------------

  /// Helper widget untuk menampilkan info row
  ///
  /// Private method (diawali underscore) untuk internal use saja.
  /// Membuat row dengan icon, label, dan value.
  ///
  /// Parameter:
  /// - [icon]: IconData untuk ditampilkan di kiri
  /// - [label]: Label kecil di atas value
  /// - [value]: Nilai yang ditampilkan
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      // crossAxisAlignment.start untuk align ke atas
      // Berguna jika value panjang dan wrap ke baris baru
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon dengan warna abu-abu
        Icon(icon, size: 20, color: Colors.grey[600]),

        // Spasi horizontal
        const SizedBox(width: 8),

        // Label dan Value dalam Column
        // Expanded agar bisa wrap jika terlalu panjang
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label (text kecil)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              // Value (text normal)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
