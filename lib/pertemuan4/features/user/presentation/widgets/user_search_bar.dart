// ============================================================================
// PERTEMUAN 4: USER SEARCH BAR WIDGET
// ============================================================================

import 'package:flutter/material.dart';

/// Widget search bar
class UserSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final String searchQuery;

  const UserSearchBar({
    super.key,
    required this.onChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan nama...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(''),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
