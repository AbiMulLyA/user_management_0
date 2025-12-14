// ============================================================================
// PERTEMUAN 4: DEPENDENCY INJECTION (INJECTOR)
// ============================================================================
//
// DEPENDENCY INJECTION adalah teknik dimana object menerima dependencies-nya
// dari luar, bukan membuat sendiri di dalamnya.
//
// ANALOGI:
// -------------------------------------------------------------------------
// ❌ Tanpa DI: Chef membuat pisau sendiri sebelum masak
// ✅ Dengan DI: Chef diberi pisau oleh restoran
//
// KENAPA PAKAI SINGLETON?
// -------------------------------------------------------------------------
// Singleton = hanya ada 1 instance dalam aplikasi
// Semua bagian aplikasi menggunakan Cubit yang SAMA
//
// URUTAN PEMBUATAN (PENTING!):
// -------------------------------------------------------------------------
// http.Client → DataSource → Repository → UseCase → Cubit
// Tidak boleh terbalik karena ada dependency antar object
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
class Injector {
  // =========================================================================
  // SINGLETON PATTERN
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
  late GetUsersUseCase getUsersUseCase;
  late AddUserUseCase addUserUseCase;
  late GetCitiesUseCase getCitiesUseCase;
  late UserCubit userCubit;

  // =========================================================================
  // INIT METHOD
  // =========================================================================
  void init() {
    // LANGKAH 1: HTTP Client
    httpClient = http.Client();

    // LANGKAH 2: Data Source
    userRemoteDataSource = UserRemoteDataSourceImpl(client: httpClient);

    // LANGKAH 3: Repository
    userRepository = UserRepositoryImpl(remoteDataSource: userRemoteDataSource);

    // LANGKAH 4: Use Cases
    getUsersUseCase = GetUsersUseCase(repository: userRepository);
    addUserUseCase = AddUserUseCase(repository: userRepository);
    getCitiesUseCase = GetCitiesUseCase(repository: userRepository);

    // LANGKAH 5: Cubit
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase,
      addUserUseCase: addUserUseCase,
      getCitiesUseCase: getCitiesUseCase,
    );
  }
}
