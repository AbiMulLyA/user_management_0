// ============================================================================
// PERTEMUAN 4: CITY FILTER DROPDOWN WIDGET
// ============================================================================

import 'package:flutter/material.dart';
import '../../domain/entities/city_entity.dart';

/// Widget dropdown filter kota
class CityFilterDropdown extends StatelessWidget {
  final List<CityEntity> cities;
  final String? selectedCity;
  final Function(String?) onChanged;

  const CityFilterDropdown({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        initialValue: selectedCity,
        decoration: InputDecoration(
          labelText: 'Filter berdasarkan kota',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('Semua Kota'),
          ),
          ...cities.map((city) => DropdownMenuItem<String>(
                value: city.name,
                child: Text(city.name),
              )),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
