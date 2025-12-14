// ============================================================================
// FILE: injector.dart
// DESKRIPSI: Dependency Injection Container
// LOKASI: lib/config/injector/
// ============================================================================
//
// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                    APA ITU DEPENDENCY INJECTION (DI)?                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
//
// ANALOGI SEDERHANA:
// -------------------------------------------------------------------------
// Bayangkan kamu punya mobil (class Mobil) yang butuh mesin (class Mesin).
//
// ❌ TANPA Dependency Injection:
//    class Mobil {
//      Mesin mesin = Mesin();  // Mobil MEMBUAT mesinnya sendiri
//    }
//
//    Masalah:
//    - Mobil terikat erat dengan Mesin tertentu
//    - Susah ganti mesin (misal dari bensin ke listrik)
//    - Susah testing (tidak bisa pakai mesin palsu untuk test)
//
// ✅ DENGAN Dependency Injection:
//    class Mobil {
//      final Mesin mesin;
//      Mobil({required this.mesin});  // Mesin DIBERIKAN dari luar
//    }
//
//    // Saat membuat mobil:
//    final mobil = Mobil(mesin: MesinBensin());
//    // atau
//    final mobil = Mobil(mesin: MesinListrik());
//
//    Keuntungan:
//    - Mobil tidak peduli mesin apa yang dipakai
//    - Mudah ganti mesin tanpa mengubah class Mobil
//    - Mudah testing dengan mesin palsu (mock)
//
// -------------------------------------------------------------------------
//
// DALAM KONTEKS APLIKASI INI:
// -------------------------------------------------------------------------
// - UserCubit BUTUH GetUsersUseCase
// - GetUsersUseCase BUTUH UserRepository
// - UserRepository BUTUH UserRemoteDataSource
// - UserRemoteDataSource BUTUH http.Client
//
// Semua "kebutuhan" ini DIBERIKAN dari luar, bukan dibuat di dalam class.
// File injector.dart ini yang bertugas MEMBUAT dan MEMBERIKAN semua kebutuhan.
//
// -------------------------------------------------------------------------
//
// KENAPA PAKAI SINGLETON PATTERN?
// -------------------------------------------------------------------------
// Singleton = hanya ada 1 instance dalam aplikasi
//
// Kita ingin semua bagian aplikasi menggunakan UserCubit yang SAMA,
// bukan masing-masing membuat UserCubit sendiri.
//
// Contoh:
//   Injector().userCubit  // Di halaman A
//   Injector().userCubit  // Di halaman B (sama persis dengan di A)
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
///
/// Class ini bertugas:
/// 1. MEMBUAT semua object yang dibutuhkan aplikasi
/// 2. MENYIMPAN object-object tersebut
/// 3. MEMBERIKAN object saat diminta
///
/// Dengan begitu, class lain tidak perlu tahu cara membuat dependencies-nya.
class Injector {
  // =========================================================================
  // SINGLETON PATTERN
  // =========================================================================
  //
  // CARA KERJA SINGLETON:
  // 1. _instance adalah satu-satunya Injector yang ada (dibuat sekali)
  // 2. factory Injector() selalu mengembalikan _instance yang sama
  // 3. _internal() adalah constructor private, tidak bisa dipanggil dari luar
  //
  // CONTOH PENGGUNAAN:
  //   final injector1 = Injector();  // Dapat _instance
  //   final injector2 = Injector();  // Dapat _instance yang SAMA
  //   print(injector1 == injector2); // TRUE - object yang sama!
  //
  // =========================================================================

  /// Satu-satunya instance dari Injector
  static final Injector _instance = Injector._internal();

  /// Factory constructor - selalu return instance yang sama
  factory Injector() => _instance;

  /// Constructor private - hanya dipanggil sekali saat _instance dibuat
  Injector._internal();

  // =========================================================================
  // DAFTAR DEPENDENCIES
  // =========================================================================
  //
  // 'late' artinya: "Variabel ini akan diisi nanti, bukan sekarang"
  // Kita isi semua variabel ini di method init()
  //
  // =========================================================================

  /// HTTP Client - untuk request ke API
  late http.Client httpClient;

  /// Data Source - komunikasi langsung dengan API
  late UserRemoteDataSource userRemoteDataSource;

  /// Repository - abstraksi untuk akses data
  late UserRepository userRepository;

  /// Use Cases - satu aksi spesifik
  late GetUsersUseCase getUsersUseCase;
  late AddUserUseCase addUserUseCase;
  late GetCitiesUseCase getCitiesUseCase;

  /// Cubit - state management untuk UI
  late UserCubit userCubit;

  // =========================================================================
  // METHOD INIT - MEMBUAT SEMUA DEPENDENCIES
  // =========================================================================
  //
  // URUTAN PEMBUATAN PENTING!
  // -------------------------------------------------------------------------
  // Harus sesuai dengan siapa butuh siapa:
  //
  //   http.Client
  //       ↓
  //   UserRemoteDataSource (butuh http.Client)
  //       ↓
  //   UserRepository (butuh DataSource)
  //       ↓
  //   UseCases (butuh Repository)
  //       ↓
  //   UserCubit (butuh UseCases)
  //
  // Kalau urutannya salah, akan error karena dependency belum ada!
  //
  // =========================================================================

  void init() {
    // LANGKAH 1: Buat HTTP Client
    // http.Client adalah bawaan dari package http
    httpClient = http.Client();

    // LANGKAH 2: Buat Data Source
    // DataSource butuh httpClient untuk request ke API
    // Di sini kita BERIKAN httpClient yang sudah dibuat di atas
    userRemoteDataSource = UserRemoteDataSourceImpl(
      client: httpClient, // <- Dependency Injection!
    );

    // LANGKAH 3: Buat Repository
    // Repository butuh DataSource untuk ambil data
    userRepository = UserRepositoryImpl(
      remoteDataSource: userRemoteDataSource, // <- Dependency Injection!
    );

    // LANGKAH 4: Buat Use Cases
    // Setiap use case butuh repository
    getUsersUseCase = GetUsersUseCase(
      repository: userRepository, // <- Dependency Injection!
    );

    addUserUseCase = AddUserUseCase(
      repository: userRepository, // <- Dependency Injection!
    );

    getCitiesUseCase = GetCitiesUseCase(
      repository: userRepository, // <- Dependency Injection!
    );

    // LANGKAH 5: Buat Cubit
    // Cubit butuh semua use cases
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase, // <- Dependency Injection!
      addUserUseCase: addUserUseCase, // <- Dependency Injection!
      getCitiesUseCase: getCitiesUseCase, // <- Dependency Injection!
    );
  }

  /// Reset cubit (untuk testing atau refresh state)
  void resetCubit() {
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase,
      addUserUseCase: addUserUseCase,
      getCitiesUseCase: getCitiesUseCase,
    );
  }
}
