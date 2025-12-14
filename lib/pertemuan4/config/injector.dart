// ============================================================================
// PERTEMUAN 4: INJECTOR - DEPENDENCY INJECTION CONTAINER
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 4!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 3.
//
// Di Pertemuan 3, DI dilakukan secara manual di main.dart:
//   final httpClient = http.Client();
//   final dataSource = UserRemoteDataSourceImpl(client: httpClient);
//   final repository = UserRepositoryImpl(dataSource: dataSource);
//   final cubit = UserCubit(repository: repository);
//
// Di Pertemuan 4, kode tersebut DIPINDAHKAN ke sini:
// - Semua dependencies dibuat dalam Injector class
// - Menggunakan Singleton Pattern
// - main.dart tinggal panggil Injector().init()
//
// KEUNTUNGAN:
// - Dependencies terpusat di satu tempat
// - Mudah diganti untuk testing
// - Lebih clean dan terorganisir
//
// ============================================================================

import 'package:http/http.dart' as http;
import '../features/user/data/datasources/user_remote_data_source.dart';
import '../features/user/data/repositories/user_repository_impl.dart';
import '../features/user/domain/repositories/user_repository.dart';
import '../features/user/domain/usecases/get_users_usecase.dart';
import '../features/user/domain/usecases/add_user_usecase.dart';
import '../features/user/domain/usecases/get_cities_usecase.dart';
import '../features/user/presentation/bloc/user_cubit.dart';

/// Dependency Injection Container
///
/// 📌 JEJAK PERTEMUAN 3:
/// Kode ini DIPINDAHKAN dari main.dart
class Injector {
  // =========================================================================
  // SINGLETON PATTERN
  // =========================================================================
  // 🆕 BARU: Menggunakan singleton agar hanya ada 1 instance
  // =========================================================================
  static final Injector _instance = Injector._internal();
  factory Injector() => _instance;
  Injector._internal();

  // =========================================================================
  // DEPENDENCIES
  // =========================================================================
  late http.Client httpClient;
  late UserRemoteDataSource userRemoteDataSource;
  late UserRepository userRepository;
  // 🆕 BARU: Use Cases (tidak ada di Pertemuan 3)
  late GetUsersUseCase getUsersUseCase;
  late AddUserUseCase addUserUseCase;
  late GetCitiesUseCase getCitiesUseCase;
  late UserCubit userCubit;

  // =========================================================================
  // 📌 JEJAK PERTEMUAN 3: Kode ini DULU ada di main()
  // =========================================================================
  // KODE LAMA di main.dart (Pertemuan 3):
  // -----------------------------------------------------------------
  // void main() {
  //   final httpClient = http.Client();
  //   final userDataSource = UserRemoteDataSourceImpl(client: httpClient);
  //   final userRepository = UserRepositoryImpl(dataSource: userDataSource);
  //   final userCubit = UserCubit(repository: userRepository);
  //   runApp(MyApp(userCubit: userCubit));
  // }
  //
  // SEKARANG: Dipindahkan ke method init() di bawah ini
  // -----------------------------------------------------------------
  void init() {
    // LANGKAH 1: HTTP Client
    httpClient = http.Client();

    // LANGKAH 2: Data Source
    userRemoteDataSource = UserRemoteDataSourceImpl(client: httpClient);

    // LANGKAH 3: Repository
    userRepository = UserRepositoryImpl(remoteDataSource: userRemoteDataSource);

    // =====================================================================
    // 🆕 LANGKAH 4 BARU: Use Cases (tidak ada di Pertemuan 3)
    // =====================================================================
    // Di Pertemuan 3, Cubit langsung panggil Repository.
    // Di Pertemuan 4, ada Use Case sebagai perantara.
    // =====================================================================
    getUsersUseCase = GetUsersUseCase(repository: userRepository);
    addUserUseCase = AddUserUseCase(repository: userRepository);
    getCitiesUseCase = GetCitiesUseCase(repository: userRepository);

    // LANGKAH 5: Cubit
    // 🔄 PERUBAHAN:
    // Pertemuan 3: UserCubit(repository: repository)
    // Pertemuan 4: UserCubit(getUsersUseCase: ..., addUserUseCase: ...)
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase,
      addUserUseCase: addUserUseCase,
      getCitiesUseCase: getCitiesUseCase,
    );
  }
}
