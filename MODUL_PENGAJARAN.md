# MODUL PENGAJARAN

# Flutter Clean Architecture

## 4 Pertemuan @ 90 Menit

---

**Mata Kuliah:** Pengembangan Aplikasi Mobile  
**Materi:** Clean Architecture dengan Flutter  
**Target Peserta:** Mahasiswa dengan pengetahuan dasar Flutter  
**Durasi:** 4 Pertemuan x 90 Menit

---

# DAFTAR ISI

1. [Pendahuluan](#pendahuluan)
2. [Pertemuan 1: Flutter Basic](#pertemuan-1-flutter-basic)
3. [Pertemuan 2: State Management dengan Cubit](#pertemuan-2-state-management)
4. [Pertemuan 3: Data Layer](#pertemuan-3-data-layer)
5. [Pertemuan 4: Clean Architecture Lengkap](#pertemuan-4-clean-architecture)
6. [Ringkasan Evolusi Arsitektur](#ringkasan-evolusi)
7. [Referensi](#referensi)

---

# PENDAHULUAN

## Tujuan Pembelajaran

Setelah menyelesaikan 4 pertemuan ini, mahasiswa diharapkan mampu:

1. Memahami pentingnya arsitektur dalam pengembangan aplikasi
2. Mengimplementasikan State Management menggunakan Cubit/BLoC
3. Menerapkan Repository Pattern untuk abstraksi data
4. Membangun aplikasi Flutter dengan Clean Architecture
5. Memahami prinsip Separation of Concerns dan Dependency Injection

## Metode Pembelajaran

- **Live Coding:** Instruktur menunjukkan kode yang sudah jadi sambil menjelaskan
- **Hands-on Practice:** Mahasiswa mengikuti dan memodifikasi kode
- **Progressive Learning:** Setiap pertemuan membangun di atas pertemuan sebelumnya

## Prasyarat

- Pemahaman dasar Dart programming
- Pemahaman dasar Flutter widgets (StatelessWidget, StatefulWidget)
- Pemahaman dasar HTTP dan REST API

## Teknologi yang Digunakan

| Package      | Versi  | Kegunaan          |
| ------------ | ------ | ----------------- |
| flutter      | SDK    | Framework utama   |
| http         | ^1.1.0 | HTTP client       |
| flutter_bloc | ^8.1.3 | State management  |
| equatable    | ^2.0.5 | Object comparison |

---

# PERTEMUAN 1: FLUTTER BASIC

## (Tanpa Arsitektur)

### Durasi: 90 Menit

### Tujuan Pertemuan

1. Memahami struktur dasar aplikasi Flutter
2. Mengimplementasikan HTTP request sederhana
3. Memahami StatefulWidget dan lifecycle-nya
4. Mengenali masalah kode tanpa arsitektur yang baik

### Alokasi Waktu

| Waktu         | Durasi   | Aktivitas                                 |
| ------------- | -------- | ----------------------------------------- |
| 00:00 - 00:15 | 15 menit | Pengenalan project dan demo aplikasi      |
| 00:15 - 00:30 | 15 menit | Penjelasan main.dart dan MaterialApp      |
| 00:30 - 00:50 | 20 menit | Penjelasan UserModel dan fromJson         |
| 00:50 - 01:20 | 30 menit | Penjelasan UserListPage (HTTP, State, UI) |
| 01:20 - 01:30 | 10 menit | Diskusi masalah kode saat ini             |

### Struktur Folder

```
pertemuan1/
├── main.dart              # Entry point aplikasi
├── models/
│   └── user_model.dart    # Model data user
├── pages/
│   └── user_list_page.dart # Halaman utama (semua logic di sini)
└── README.md              # Dokumentasi
```

### Konsep yang Dipelajari

#### 1. Entry Point (main.dart)

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      home: const UserListPage(),
    );
  }
}
```

**Poin Penting:**

- `main()` adalah entry point aplikasi
- `runApp()` memulai aplikasi Flutter
- `MaterialApp` menyediakan theming dan navigasi

#### 2. Model dengan fromJson

```dart
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
```

**Poin Penting:**

- `final` membuat property immutable
- `factory` constructor untuk parsing JSON
- `??` untuk null safety

#### 3. StatefulWidget dengan HTTP

```dart
class UserListPage extends StatefulWidget {
  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserModel> users = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() { isLoading = true; });

    try {
      final response = await http.get(Uri.parse('API_URL'));
      final List<dynamic> jsonList = json.decode(response.body);

      setState(() {
        users = jsonList.map((json) => UserModel.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }
}
```

**Poin Penting:**

- `initState()` dipanggil sekali saat widget dibuat
- `setState()` memberitahu Flutter untuk rebuild UI
- `async/await` untuk operasi asynchronous

### Masalah yang Diidentifikasi

> **CATATAN UNTUK PENGAJAR:**
> Jelaskan bahwa kode ini SENGAJA dibuat tidak ideal untuk menunjukkan masalah.

1. **Semua Logic di Satu File**

   - UI, business logic, dan data access tercampur
   - Sulit dibaca dan dipahami

2. **Sulit untuk Testing**

   - Tidak bisa test logic tanpa UI
   - Harus mock HTTP di widget test

3. **Tidak Reusable**

   - Jika ada halaman lain yang butuh users, harus copy-paste
   - Perubahan di satu tempat tidak otomatis berlaku di tempat lain

4. **Tidak Scalable**
   - Bayangkan jika ada 50 halaman dengan pola yang sama
   - Maintenance nightmare!

### Latihan untuk Mahasiswa

1. Ubah warna tema aplikasi menjadi hijau
2. Tambahkan field `avatar` di UserModel
3. Tampilkan jumlah total user di AppBar

---

# PERTEMUAN 2: STATE MANAGEMENT

## (Dengan Cubit)

### Durasi: 90 Menit

### Tujuan Pertemuan

1. Memahami konsep State Management
2. Mengimplementasikan Cubit dari flutter_bloc
3. Memisahkan logic dari UI
4. Menggunakan BlocBuilder untuk reaktif UI

### Alokasi Waktu

| Waktu         | Durasi   | Aktivitas                               |
| ------------- | -------- | --------------------------------------- |
| 00:00 - 00:10 | 10 menit | Review pertemuan 1 dan demo perbedaan   |
| 00:10 - 00:30 | 20 menit | Penjelasan konsep State dan Cubit       |
| 00:30 - 00:50 | 20 menit | Penjelasan UserState classes            |
| 00:50 - 01:15 | 25 menit | Penjelasan UserCubit                    |
| 01:15 - 01:30 | 15 menit | Penjelasan BlocProvider dan BlocBuilder |

### Struktur Folder

```
pertemuan2/
├── main.dart              # + BlocProvider
├── bloc/                  # FOLDER BARU
│   ├── user_cubit.dart    # Logic dipindahkan ke sini
│   └── user_state.dart    # State classes
├── models/
│   └── user_model.dart
└── pages/
    └── user_list_page.dart # Sekarang hanya UI
```

### Konsep yang Dipelajari

#### 1. State Classes

```dart
// Base class
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Concrete states
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<UserModel> users;
  const UserLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}
class UserError extends UserState {
  final String message;
  const UserError({required this.message});
}
```

**Poin Penting:**

- State merepresentasikan kondisi UI pada satu waktu
- Menggunakan `sealed class` pattern (abstract + concrete)
- `Equatable` untuk perbandingan state yang efisien

#### 2. Cubit

```dart
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> loadUsers() async {
    emit(UserLoading());

    try {
      // fetch data...
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
```

**Poin Penting:**

- `Cubit<StateType>` menentukan tipe state yang dikelola
- `super(UserInitial())` set state awal
- `emit()` menggantikan `setState()` - memicu rebuild UI

#### 3. BlocProvider dan BlocBuilder

```dart
// Di main.dart - Menyediakan Cubit
BlocProvider(
  create: (context) => UserCubit(),
  child: const UserListPage(),
)

// Di page - Menggunakan Cubit
BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    if (state is UserLoading) return CircularProgressIndicator();
    if (state is UserLoaded) return ListView(...);
    if (state is UserError) return ErrorWidget(...);
    return SizedBox.shrink();
  },
)

// Memanggil method Cubit
context.read<UserCubit>().loadUsers();
```

**Poin Penting:**

- `BlocProvider` menyediakan Cubit ke widget tree
- `BlocBuilder` rebuild otomatis saat state berubah
- `context.read<T>()` untuk akses Cubit dan panggil method

### Perbandingan dengan Pertemuan 1

| Aspek          | Pertemuan 1    | Pertemuan 2       |
| -------------- | -------------- | ----------------- |
| Widget         | StatefulWidget | StatelessWidget   |
| Update UI      | setState()     | emit()            |
| State Location | Di dalam Page  | Di Cubit terpisah |
| Logic Location | Di dalam Page  | Di Cubit terpisah |
| Testability    | Sulit          | Lebih Mudah       |

### Yang Masih Belum Ideal

- HTTP request masih di dalam Cubit
- Cubit tahu tentang detail implementasi API
- Sulit mock untuk testing

**Akan diperbaiki di Pertemuan 3!**

### Latihan untuk Mahasiswa

1. Tambahkan state `UserEmpty` untuk kondisi list kosong
2. Implementasikan method `refreshUsers()` di Cubit
3. Tambahkan pull-to-refresh di UI

---

# PERTEMUAN 3: DATA LAYER

## (Repository & DataSource)

### Durasi: 90 Menit

### Tujuan Pertemuan

1. Memahami Repository Pattern
2. Memisahkan data access dari business logic
3. Mengimplementasikan DataSource untuk HTTP
4. Menerapkan Dependency Injection sederhana

### Alokasi Waktu

| Waktu         | Durasi   | Aktivitas                           |
| ------------- | -------- | ----------------------------------- |
| 00:00 - 00:10 | 10 menit | Review dan demo Network tab         |
| 00:10 - 00:25 | 15 menit | Penjelasan ApiConfig                |
| 00:25 - 00:45 | 20 menit | Penjelasan DataSource               |
| 00:45 - 01:05 | 20 menit | Penjelasan Repository               |
| 01:05 - 01:20 | 15 menit | Update Cubit untuk pakai Repository |
| 01:20 - 01:30 | 10 menit | Penjelasan DI manual di main.dart   |

### Struktur Folder

```
pertemuan3/
├── main.dart              # DI manual
├── config/                # FOLDER BARU
│   └── api_config.dart    # URL terpusat
├── data/                  # FOLDER BARU
│   ├── models/
│   │   ├── user_model.dart
│   │   └── city_model.dart
│   ├── datasources/
│   │   └── user_remote_data_source.dart
│   └── repositories/
│       └── user_repository.dart
├── bloc/
│   ├── user_cubit.dart
│   └── user_state.dart
└── pages/
    ├── user_list_page.dart
    └── add_user_page.dart  # HALAMAN BARU
```

### Konsep yang Dipelajari

#### 1. API Config

```dart
class ApiConfig {
  static const String baseUrl = 'https://api.example.com';
  static const String userEndpoint = '/user';
  static String get userUrl => '$baseUrl$userEndpoint';
}
```

**Poin Penting:**

- URL terpusat, mudah diubah
- Bisa switch environment (dev, staging, prod)

#### 2. DataSource

```dart
// Interface
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(UserModel user);
}

// Implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.get(Uri.parse(ApiConfig.userUrl));
    // parse response...
  }
}
```

**Poin Penting:**

- Abstract class sebagai kontrak
- Implementation berisi detail HTTP
- Dependency Injection untuk http.Client

#### 3. Repository

```dart
// Interface
abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<UserModel> addUser(UserModel user);
}

// Implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserModel>> getUsers() async {
    return await dataSource.getUsers();
  }
}
```

**Poin Penting:**

- Repository sebagai abstraksi
- Tidak tahu detail HTTP (itu tugas DataSource)
- Bisa tambah caching, local DB, dll

#### 4. DI Manual di main.dart

```dart
void main() {
  final httpClient = http.Client();
  final dataSource = UserRemoteDataSourceImpl(client: httpClient);
  final repository = UserRepositoryImpl(dataSource: dataSource);
  final cubit = UserCubit(repository: repository);

  runApp(MyApp(userCubit: cubit));
}
```

**Poin Penting:**

- Urutan pembuatan penting (dependency chain)
- Semua dependencies dibuat di satu tempat

### Alur Data

```
UI → Cubit → Repository → DataSource → API
       ↑          ↑            ↑
    (logic)   (abstraksi)   (HTTP)
```

### Perbandingan dengan Pertemuan 2

| Aspek         | Pertemuan 2 | Pertemuan 3    |
| ------------- | ----------- | -------------- |
| HTTP Location | Di Cubit    | Di DataSource  |
| URL Config    | Hardcoded   | Di ApiConfig   |
| Data Access   | Langsung    | Via Repository |
| DI            | Tidak ada   | Manual         |

### Latihan untuk Mahasiswa

1. Tambahkan method `deleteUser(String id)` di semua layer
2. Implementasikan error handling yang lebih baik
3. Tambahkan loading indicator di Add User form

---

# PERTEMUAN 4: CLEAN ARCHITECTURE

## (Implementasi Lengkap)

### Durasi: 90 Menit

### Tujuan Pertemuan

1. Memahami 3 Layer Clean Architecture
2. Membedakan Entity dan Model
3. Mengimplementasikan Use Cases
4. Menerapkan Dependency Injection dengan Injector

### Alokasi Waktu

| Waktu         | Durasi   | Aktivitas                             |
| ------------- | -------- | ------------------------------------- |
| 00:00 - 00:15 | 15 menit | Penjelasan diagram Clean Architecture |
| 00:15 - 00:30 | 15 menit | Penjelasan Entity vs Model            |
| 00:30 - 00:50 | 20 menit | Penjelasan Use Cases                  |
| 00:50 - 01:10 | 20 menit | Penjelasan Injector (DI Container)    |
| 01:10 - 01:25 | 15 menit | Review alur lengkap dengan tracing    |
| 01:25 - 01:30 | 5 menit  | Kesimpulan dan wrap-up                |

### Struktur Folder (Clean Architecture)

```
pertemuan4/
├── main.dart
├── config/
│   ├── api_config.dart
│   └── injector.dart          # DI Container
│
└── features/user/
    ├── domain/                 # DOMAIN LAYER
    │   ├── entities/
    │   │   ├── user_entity.dart
    │   │   └── city_entity.dart
    │   ├── repositories/
    │   │   └── user_repository.dart   # Interface
    │   └── usecases/
    │       ├── get_users_usecase.dart
    │       ├── add_user_usecase.dart
    │       └── get_cities_usecase.dart
    │
    ├── data/                   # DATA LAYER
    │   ├── models/
    │   │   ├── user_model.dart
    │   │   └── city_model.dart
    │   ├── datasources/
    │   │   └── user_remote_data_source.dart
    │   └── repositories/
    │       └── user_repository_impl.dart
    │
    └── presentation/           # PRESENTATION LAYER
        ├── bloc/
        │   ├── user_cubit.dart
        │   └── user_state.dart
        ├── pages/
        │   ├── user_list_page.dart
        │   └── add_user_page.dart
        └── widgets/
            ├── user_card.dart
            ├── user_search_bar.dart
            └── city_filter_dropdown.dart
```

### Konsep yang Dipelajari

#### 1. Diagram Clean Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                      │
│    Pages, Widgets, Cubit, State                         │
│    Fokus: UI dan State Management                       │
└───────────────────────────┬─────────────────────────────┘
                            │ depends on
                            ▼
┌─────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                          │
│    Entity, Use Cases, Repository Interface              │
│    Fokus: Business Logic                                │
│    ⭐ TIDAK BERGANTUNG PADA LAYER LAIN                  │
└───────────────────────────┬─────────────────────────────┘
                            │ implemented by
                            ▼
┌─────────────────────────────────────────────────────────┐
│                     DATA LAYER                           │
│    Model, DataSource, Repository Implementation         │
│    Fokus: Akses Data (API, Database)                    │
└─────────────────────────────────────────────────────────┘
```

**Dependency Rule:**

- Layer luar (Presentation) boleh tahu layer dalam (Domain)
- Layer dalam (Domain) TIDAK BOLEH tahu layer luar

#### 2. Entity vs Model

```dart
// ENTITY (Domain Layer) - Data murni
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

// MODEL (Data Layer) - Extends Entity + Parsing
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }
}
```

| Aspek        | Entity     | Model            |
| ------------ | ---------- | ---------------- |
| Layer        | Domain     | Data             |
| Tujuan       | Data murni | Parsing JSON     |
| Dependencies | Tidak ada  | Extends Entity   |
| Methods      | Tidak ada  | fromJson, toJson |

#### 3. Use Cases

```dart
class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  Future<List<UserEntity>> execute() async {
    return await repository.getUsers();
  }
}
```

**Prinsip Use Case:**

- **Single Responsibility:** 1 use case = 1 aksi
- **Business Logic:** Validasi, transformasi, aturan bisnis
- **Orchestration:** Koordinasi satu atau lebih repository

#### 4. Injector (DI Container)

```dart
class Injector {
  // Singleton Pattern
  static final Injector _instance = Injector._internal();
  factory Injector() => _instance;
  Injector._internal();

  // Dependencies
  late http.Client httpClient;
  late UserRemoteDataSource userRemoteDataSource;
  late UserRepository userRepository;
  late GetUsersUseCase getUsersUseCase;
  late UserCubit userCubit;

  void init() {
    httpClient = http.Client();
    userRemoteDataSource = UserRemoteDataSourceImpl(client: httpClient);
    userRepository = UserRepositoryImpl(remoteDataSource: userRemoteDataSource);
    getUsersUseCase = GetUsersUseCase(repository: userRepository);
    userCubit = UserCubit(getUsersUseCase: getUsersUseCase);
  }
}
```

**Keuntungan Injector:**

- Semua dependencies di satu tempat
- Mudah diganti untuk testing
- Urutan pembuatan terjamin

### Alur Data Lengkap

```
User klik "Refresh"
        │
        ▼
┌───────────────────┐
│   UserListPage    │  → UI Layer
└─────────┬─────────┘
          │ context.read<UserCubit>().loadData()
          ▼
┌───────────────────┐
│    UserCubit      │  → State Management
└─────────┬─────────┘
          │ getUsersUseCase.execute()
          ▼
┌───────────────────┐
│  GetUsersUseCase  │  → Business Logic
└─────────┬─────────┘
          │ repository.getUsers()
          ▼
┌───────────────────┐
│  UserRepository   │  → Interface
└─────────┬─────────┘
          │ (implemented by)
          ▼
┌───────────────────┐
│ UserRepositoryImpl│  → Implementation
└─────────┬─────────┘
          │ dataSource.getUsers()
          ▼
┌───────────────────┐
│ RemoteDataSource  │  → HTTP Client
└─────────┬─────────┘
          │ http.get()
          ▼
┌───────────────────┐
│     REST API      │  → Server
└───────────────────┘
```

### Checklist Clean Architecture

- [ ] Domain Layer TIDAK import dari Data atau Presentation
- [ ] Use Case menerima Repository Interface (bukan Implementation)
- [ ] Cubit menerima Use Case (bukan Repository langsung)
- [ ] Model extends Entity
- [ ] Semua dependencies dibuat di Injector

---

# RINGKASAN EVOLUSI

## Tabel Perbandingan Lengkap

| Aspek             | P1             | P2              | P3              | P4              |
| ----------------- | -------------- | --------------- | --------------- | --------------- |
| **Files**         | 4              | 6               | 11              | 21              |
| **Widget Type**   | StatefulWidget | StatelessWidget | StatelessWidget | StatelessWidget |
| **State Mgmt**    | setState()     | Cubit           | Cubit           | Cubit           |
| **HTTP Location** | Page           | Cubit           | DataSource      | DataSource      |
| **URL Config**    | Hardcoded      | Hardcoded       | ApiConfig       | ApiConfig       |
| **Repository**    | ❌             | ❌              | ✅              | ✅              |
| **Entity**        | ❌             | ❌              | ❌              | ✅              |
| **Use Cases**     | ❌             | ❌              | ❌              | ✅              |
| **DI**            | ❌             | ❌              | Manual          | Injector        |
| **Widgets**       | In Page        | In Page         | In Page         | Separate        |

## Diagram Evolusi

```
PERTEMUAN 1:
┌───────────────────────────────────────┐
│      PAGE (Semua di sini)             │
│  UI + Logic + HTTP + State + Model    │
└───────────────────────────────────────┘

PERTEMUAN 2:
┌─────────────┐     ┌─────────────────┐
│    PAGE     │ ←── │  CUBIT + STATE  │
│   (UI)      │     │ (Logic + HTTP)  │
└─────────────┘     └─────────────────┘

PERTEMUAN 3:
┌─────────┐   ┌─────────┐   ┌────────────┐   ┌────────────┐
│  PAGE   │ → │  CUBIT  │ → │ REPOSITORY │ → │ DATASOURCE │ → API
│  (UI)   │   │ (Logic) │   │ (Abstract) │   │   (HTTP)   │
└─────────┘   └─────────┘   └────────────┘   └────────────┘

PERTEMUAN 4 (CLEAN ARCHITECTURE):
┌─────────────────────────────────────────────────────┐
│               PRESENTATION LAYER                     │
│  ┌────────┐   ┌───────┐   ┌─────────────┐          │
│  │WIDGETS │   │ PAGES │   │ CUBIT/STATE │          │
│  └────────┘   └───────┘   └──────┬──────┘          │
└──────────────────────────────────┼──────────────────┘
                                   ▼
┌─────────────────────────────────────────────────────┐
│                 DOMAIN LAYER                         │
│  ┌─────────┐   ┌──────────┐   ┌───────────────┐    │
│  │ENTITIES │   │ USECASES │   │ REPO INTERFACE│    │
│  └─────────┘   └─────┬────┘   └───────┬───────┘    │
└──────────────────────┼────────────────┼─────────────┘
                       │                │ implements
                       ▼                ▼
┌─────────────────────────────────────────────────────┐
│                   DATA LAYER                         │
│  ┌────────┐   ┌───────────┐   ┌────────────┐       │
│  │ MODELS │   │ REPO IMPL │   │ DATASOURCE │ → API │
│  └────────┘   └───────────┘   └────────────┘       │
└─────────────────────────────────────────────────────┘
```

## Poin Kunci per Pertemuan

| Pertemuan | Fokus Utama                                     |
| --------- | ----------------------------------------------- |
| **P1**    | "Ini yang terjadi kalau tidak pakai arsitektur" |
| **P2**    | "Pisahkan STATE dari UI dengan Cubit"           |
| **P3**    | "Pisahkan DATA ACCESS dengan Repository"        |
| **P4**    | "Pisahkan BUSINESS LOGIC dengan Use Case"       |

---

# REFERENSI

## Dokumentasi Resmi

1. Flutter Documentation: https://docs.flutter.dev/
2. Bloc Library: https://bloclibrary.dev/
3. Clean Architecture by Uncle Bob: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

## Package yang Digunakan

1. http: https://pub.dev/packages/http
2. flutter_bloc: https://pub.dev/packages/flutter_bloc
3. equatable: https://pub.dev/packages/equatable

## API Testing

Base URL: `https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate`

| Endpoint | Method | Deskripsi              |
| -------- | ------ | ---------------------- |
| /user    | GET    | Mendapatkan semua user |
| /user    | POST   | Menambah user baru     |
| /city    | GET    | Mendapatkan semua kota |

---

**Dokumen ini dibuat untuk keperluan pengajaran.**
**Silakan modifikasi sesuai kebutuhan.**
