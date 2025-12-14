// ============================================================================
// FILE: injector.dart
// DESKRIPSI: Dependency Injection Container
// LOKASI: lib/config/injector/
// ============================================================================
//
// DEPENDENCY INJECTION (DI) adalah design pattern dimana object menerima
// dependencies-nya dari luar, bukan membuat sendiri di dalamnya.
//
// MENGAPA MENGGUNAKAN DI?
// 1. Loose Coupling - Class tidak terikat erat dengan implementasi konkrit
// 2. Testability - Mudah untuk mock dependencies saat testing
// 3. Maintainability - Mudah mengganti implementasi tanpa mengubah banyak code
// 4. Single Responsibility - Tiap class fokus pada tugasnya sendiri
//
// CARA KERJA:
// 1. Injector dibuat sebagai Singleton (hanya ada 1 instance)
// 2. Method init() membuat semua dependencies
// 3. Dependencies disimpan dan bisa diakses dari mana saja
//
// ============================================================================

import 'package:http/http.dart' as http;
import '../../features/user/data/datasources/remote/user_remote_data_source.dart';
import '../../features/user/data/repository_impl/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usecases/get_users_usecase.dart';
import '../../features/user/domain/usecases/add_user_usecase.dart';
import '../../features/user/domain/usecases/get_cities_usecase.dart';
import '../../features/user/presentation/bloc/user_cubit.dart';

/// Dependency Injection Container
/// Berisi semua dependencies yang dibutuhkan aplikasi
///
/// Menggunakan SINGLETON PATTERN:
/// - Hanya ada 1 instance Injector dalam aplikasi
/// - Instance yang sama digunakan di seluruh aplikasi
class Injector {
  // -------------------------------------------------------------------------
  // SINGLETON PATTERN IMPLEMENTATION
  // -------------------------------------------------------------------------
  // _instance: satu-satunya instance dari Injector (private)
  // factory Injector(): mengembalikan _instance yang sudah ada
  // _internal(): constructor private yang hanya dipanggil sekali
  // -------------------------------------------------------------------------

  /// Instance singleton (static = shared across all uses)
  static final Injector _instance = Injector._internal();

  /// Factory constructor - mengembalikan instance yang sudah ada
  /// Setiap kali Injector() dipanggil, akan return _instance yang sama
  factory Injector() => _instance;

  /// Private constructor - hanya dipanggil sekali saat pertama kali
  Injector._internal();

  // =========================================================================
  // DEPENDENCIES
  // =========================================================================
  // Semua dependencies dideklarasikan dengan 'late' keyword
  // 'late' artinya variabel akan diinisialisasi nanti (di method init)
  // =========================================================================

  // -------------------------------------------------------------------------
  // EXTERNAL DEPENDENCIES
  // -------------------------------------------------------------------------
  /// HTTP Client untuk melakukan request ke API
  /// Digunakan oleh DataSource untuk komunikasi dengan server
  late http.Client httpClient;

  // -------------------------------------------------------------------------
  // DATA LAYER DEPENDENCIES
  // -------------------------------------------------------------------------
  /// Remote Data Source - bertanggung jawab untuk komunikasi dengan API
  /// Menghandle parsing JSON dan HTTP requests
  late UserRemoteDataSource userRemoteDataSource;

  // -------------------------------------------------------------------------
  // DOMAIN LAYER DEPENDENCIES
  // -------------------------------------------------------------------------
  /// Repository - abstraksi untuk akses data
  /// Menggunakan interface (abstract class) untuk loose coupling
  late UserRepository userRepository;

  /// Use Cases - berisi business logic spesifik
  /// Setiap use case mewakili satu aksi yang bisa dilakukan user
  late GetUsersUseCase getUsersUseCase;
  late AddUserUseCase addUserUseCase;
  late GetCitiesUseCase getCitiesUseCase;

  // -------------------------------------------------------------------------
  // PRESENTATION LAYER DEPENDENCIES
  // -------------------------------------------------------------------------
  /// Cubit - state management untuk UI
  /// Menghubungkan UI dengan business logic
  late UserCubit userCubit;

  // =========================================================================
  // INITIALIZATION METHOD
  // =========================================================================
  /// Initialize semua dependencies
  ///
  /// URUTAN INISIALISASI PENTING!
  /// Dependencies harus dibuat sesuai urutan dependency:
  /// 1. External (http client)
  /// 2. Data Sources (butuh http client)
  /// 3. Repositories (butuh data sources)
  /// 4. Use Cases (butuh repositories)
  /// 5. Cubits (butuh use cases)
  void init() {
    // -----------------------------------------------------------------------
    // STEP 1: External Dependencies
    // -----------------------------------------------------------------------
    // http.Client adalah class bawaan dari package http
    // Digunakan untuk melakukan HTTP requests (GET, POST, dll)
    httpClient = http.Client();

    // -----------------------------------------------------------------------
    // STEP 2: Data Sources
    // -----------------------------------------------------------------------
    // DataSource adalah class yang berinteraksi langsung dengan API
    // Membutuhkan httpClient untuk melakukan requests
    userRemoteDataSource = UserRemoteDataSourceImpl(
      client: httpClient,
    );

    // -----------------------------------------------------------------------
    // STEP 3: Repositories
    // -----------------------------------------------------------------------
    // Repository mengabstraksi DataSource
    // Domain layer hanya mengenal Repository interface, tidak DataSource
    // Ini memungkinkan kita mengganti DataSource tanpa mengubah domain
    userRepository = UserRepositoryImpl(
      remoteDataSource: userRemoteDataSource,
    );

    // -----------------------------------------------------------------------
    // STEP 4: Use Cases
    // -----------------------------------------------------------------------
    // Use Case berisi business logic untuk satu aksi spesifik
    // Setiap use case hanya melakukan satu hal (Single Responsibility)

    // Use case untuk mendapatkan daftar user
    getUsersUseCase = GetUsersUseCase(
      repository: userRepository,
    );

    // Use case untuk menambahkan user baru
    addUserUseCase = AddUserUseCase(
      repository: userRepository,
    );

    // Use case untuk mendapatkan daftar kota
    getCitiesUseCase = GetCitiesUseCase(
      repository: userRepository,
    );

    // -----------------------------------------------------------------------
    // STEP 5: Cubits (State Management)
    // -----------------------------------------------------------------------
    // Cubit menghubungkan UI dengan use cases
    // UI memanggil method di Cubit, Cubit memanggil use case
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase,
      addUserUseCase: addUserUseCase,
      getCitiesUseCase: getCitiesUseCase,
    );
  }

  // =========================================================================
  // UTILITY METHODS
  // =========================================================================

  /// Reset cubit (untuk testing atau refresh state)
  /// Membuat instance baru dari UserCubit dengan dependencies yang sama
  void resetCubit() {
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase,
      addUserUseCase: addUserUseCase,
      getCitiesUseCase: getCitiesUseCase,
    );
  }
}
