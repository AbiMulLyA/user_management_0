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
class Injector {
  // Singleton instance
  static final Injector _instance = Injector._internal();
  factory Injector() => _instance;
  Injector._internal();

  // HTTP Client
  late http.Client httpClient;

  // Data Sources
  late UserRemoteDataSource userRemoteDataSource;

  // Repositories
  late UserRepository userRepository;

  // Use Cases
  late GetUsersUseCase getUsersUseCase;
  late AddUserUseCase addUserUseCase;
  late GetCitiesUseCase getCitiesUseCase;

  // Cubits
  late UserCubit userCubit;

  /// Initialize semua dependencies
  void init() {
    // External
    httpClient = http.Client();

    // Data Sources
    userRemoteDataSource = UserRemoteDataSourceImpl(
      client: httpClient,
    );

    // Repositories
    userRepository = UserRepositoryImpl(
      remoteDataSource: userRemoteDataSource,
    );

    // Use Cases
    getUsersUseCase = GetUsersUseCase(
      repository: userRepository,
    );

    addUserUseCase = AddUserUseCase(
      repository: userRepository,
    );

    getCitiesUseCase = GetCitiesUseCase(
      repository: userRepository,
    );

    // Cubits
    userCubit = UserCubit(
      getUsersUseCase: getUsersUseCase,
      addUserUseCase: addUserUseCase,
      getCitiesUseCase: getCitiesUseCase,
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
