# Pertemuan 3: Data Layer (Repository & DataSource)

## 🎯 Tujuan Pembelajaran

Pada pertemuan ini, murid akan mempelajari:

1. **Repository Pattern**: Abstraksi akses data
2. **DataSource**: Implementasi komunikasi API
3. **Separation of Concerns**: Cubit tidak tahu tentang HTTP
4. **Abstract Class sebagai Interface**: Kontrak antar layer
5. **Fitur Lengkap**: Search, filter, CRUD

## 📁 Struktur Folder

```
pertemuan3/
├── main.dart                         # Entry point dengan DI manual
├── config/
│   └── api_config.dart               # Konfigurasi URL API
├── data/
│   ├── models/
│   │   ├── user_model.dart           # Model dengan fromJson/toJson
│   │   └── city_model.dart           # Model City
│   ├── datasources/
│   │   └── user_remote_data_source.dart  # Komunikasi API
│   └── repositories/
│       └── user_repository.dart      # Abstraksi akses data
├── bloc/
│   ├── user_cubit.dart               # Cubit dengan Repository
│   └── user_state.dart               # State dengan filter
├── pages/
│   ├── user_list_page.dart           # List dengan search & filter
│   └── add_user_page.dart            # Form tambah user
└── README.md
```

## 🔄 Perbandingan dengan Pertemuan Sebelumnya

| Aspek        | Pertemuan 2    | Pertemuan 3           |
| ------------ | -------------- | --------------------- |
| HTTP Request | Di Cubit       | Di DataSource         |
| URL Config   | Hardcoded      | Di ApiConfig          |
| Data Access  | Langsung       | Via Repository        |
| Fitur        | Get Users saja | + Add, Search, Filter |

## 📚 Materi yang Dibahas

### 1. DataSource (user_remote_data_source.dart)

```dart
// Interface
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(UserModel user);
}

// Implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  // ... implementasi HTTP
}
```

### 2. Repository (user_repository.dart)

```dart
// Interface
abstract class UserRepository {
  Future<List<UserModel>> getUsers();
}

// Implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource dataSource;
  // ... implementasi
}
```

### 3. Cubit dengan Repository

```dart
class UserCubit extends Cubit<UserState> {
  final UserRepository repository; // Hanya tahu Repository

  Future<void> loadData() async {
    final users = await repository.getUsers(); // Tidak tahu HTTP
  }
}
```

### 4. Manual Dependency Injection (main.dart)

```dart
void main() {
  final httpClient = http.Client();
  final dataSource = UserRemoteDataSourceImpl(client: httpClient);
  final repository = UserRepositoryImpl(dataSource: dataSource);
  final cubit = UserCubit(repository: repository);

  runApp(MyApp(userCubit: cubit));
}
```

## 🔄 Alur Data

```
┌──────────────────────────────────────────────────────────────────┐
│                          USER CLICK                               │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  UI (Page)                                                        │
│  context.read<UserCubit>().loadData()                            │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  Cubit                                                            │
│  repository.getUsers()                                           │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  Repository                                                       │
│  dataSource.getUsers()                                           │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  DataSource                                                       │
│  http.get(ApiConfig.userUrl)                                     │
└──────────────────────────┬───────────────────────────────────────┘
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│  API                                                              │
└──────────────────────────────────────────────────────────────────┘
```

## ⚠️ Yang Masih Belum Ideal

1. **Belum Ada Entity**

   - Model langsung dipakai di semua layer
   - Seharusnya ada Entity di Domain Layer

2. **Belum Ada Use Cases**

   - Cubit langsung panggil Repository
   - Seharusnya ada Use Case sebagai perantara

3. **DI Masih Manual**
   - Dependencies dibuat satu-satu di main.dart
   - Seharusnya pakai Injector/Service Locator

**Di Pertemuan 4, kita akan implementasikan Clean Architecture lengkap!**

## 📝 Latihan untuk Murid

1. Tambahkan fitur delete user (di DataSource, Repository, Cubit, dan UI)
2. Tambahkan fitur edit user
3. Implementasikan error handling yang lebih baik
