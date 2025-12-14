// ============================================================================
// PERTEMUAN 4: CLEAN ARCHITECTURE LENGKAP
// ============================================================================
//
// Pada pertemuan ini, kita mengimplementasikan Clean Architecture LENGKAP:
// - Domain Layer: Entity, Use Case, Repository Interface
// - Data Layer: Model, DataSource, Repository Implementation
// - Presentation Layer: Cubit, State, Page, Widget
// - Config: API Config, Dependency Injection
//
// ARSITEKTUR 3 LAYER:
// =========================================================================
//
//   ┌─────────────────────────────────────────────────────────────────┐
//   │  PRESENTATION LAYER                                             │
//   │  Pages, Widgets, Cubit, State                                   │
//   │  Fokus: UI dan State Management                                 │
//   └────────────────────────────┬────────────────────────────────────┘
//                                │
//                                ▼
//   ┌─────────────────────────────────────────────────────────────────┐
//   │  DOMAIN LAYER                                                   │
//   │  Entity, Use Case, Repository Interface (Abstract)             │
//   │  Fokus: Business Logic                                          │
//   │  ⭐ TIDAK BERGANTUNG PADA LAYER LAIN                            │
//   └────────────────────────────┬────────────────────────────────────┘
//                                │
//                                ▼
//   ┌─────────────────────────────────────────────────────────────────┐
//   │  DATA LAYER                                                     │
//   │  Model, DataSource, Repository Implementation                   │
//   │  Fokus: Akses Data (API, Database)                              │
//   └─────────────────────────────────────────────────────────────────┘
//
// DEPENDENCY RULE:
// - Layer luar boleh tahu layer dalam
// - Layer dalam TIDAK BOLEH tahu layer luar
// - Domain Layer adalah pusat, tidak tahu Presentation atau Data
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/injector.dart';
import 'features/user/presentation/pages/user_list_page.dart';

/// Entry point aplikasi
void main() {
  // -------------------------------------------------------------------------
  // INIT DEPENDENCY INJECTION
  // -------------------------------------------------------------------------
  // Semua dependencies dibuat di Injector
  // Menggunakan Singleton pattern
  // -------------------------------------------------------------------------
  Injector().init();

  runApp(const MyApp());
}

/// Root widget aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management - Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
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
      home: BlocProvider(
        // Cubit diambil dari Injector
        create: (context) => Injector().userCubit,
        child: const UserListPage(),
      ),
    );
  }
}
