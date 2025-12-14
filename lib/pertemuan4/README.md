# Pertemuan 4: Clean Architecture Lengkap

## 🎯 Tujuan Pembelajaran

Pada pertemuan ini, murid akan mempelajari implementasi **Clean Architecture LENGKAP**:

1. **Domain Layer**: Entity, Use Case, Repository Interface
2. **Data Layer**: Model, DataSource, Repository Implementation
3. **Presentation Layer**: Cubit, State, Page, Widget
4. **Dependency Injection**: Injector dengan Singleton Pattern

## 📁 Struktur Folder (Clean Architecture)

```
pertemuan4/
├── main.dart                              # Entry point
├── config/
│   ├── api_config.dart                    # Konfigurasi API
│   └── injector.dart                      # Dependency Injection
│
└── features/
    └── user/
        ├── domain/                        # 🟢 DOMAIN LAYER
        │   ├── entities/
        │   │   ├── user_entity.dart       # Entity User
        │   │   └── city_entity.dart       # Entity City
        │   ├── repositories/
        │   │   └── user_repository.dart   # Repository Interface
        │   └── usecases/
        │       ├── get_users_usecase.dart # Use Case: Get Users
        │       ├── add_user_usecase.dart  # Use Case: Add User
        │       └── get_cities_usecase.dart# Use Case: Get Cities
        │
        ├── data/                          # 🔵 DATA LAYER
        │   ├── models/
        │   │   ├── user_model.dart        # Model User
        │   │   └── city_model.dart        # Model City
        │   ├── datasources/
        │   │   └── user_remote_data_source.dart  # API Communication
        │   └── repositories/
        │       └── user_repository_impl.dart     # Repository Impl
        │
        └── presentation/                  # 🔴 PRESENTATION LAYER
            ├── bloc/
            │   ├── user_cubit.dart        # Cubit
            │   └── user_state.dart        # State
            ├── pages/
            │   ├── user_list_page.dart    # List Page
            │   └── add_user_page.dart     # Add Page
            └── widgets/
                ├── user_card.dart         # UserCard Widget
                ├── user_search_bar.dart   # SearchBar Widget
                └── city_filter_dropdown.dart # Dropdown Widget
```

## 🏗️ Arsitektur Clean Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Pages & Widgets          Cubit & State                  │   │
│  │  (UI Components)          (State Management)             │   │
│  └────────────────────────────┬────────────────────────────┘   │
└────────────────────────────────┼────────────────────────────────┘
                                 │ depends on
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Entity           Use Cases          Repository Interface│   │
│  │  (Pure Data)      (Business Logic)   (Abstract Contract) │   │
│  └────────────────────────────┬────────────────────────────┘   │
└────────────────────────────────┼────────────────────────────────┘
                                 │ implemented by
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Model            Repository Impl      DataSource        │   │
│  │  (JSON Parsing)   (Implementation)     (API/DB Access)   │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Alur Data Lengkap

```
User Klik "Refresh"
        │
        ▼
┌───────────────────┐
│  UserListPage     │  UI Layer
│  (Widget)         │
└─────────┬─────────┘
          │ context.read<UserCubit>().loadData()
          ▼
┌───────────────────┐
│  UserCubit        │  State Management
│  (Cubit)          │
└─────────┬─────────┘
          │ getUsersUseCase.execute()
          ▼
┌───────────────────┐
│  GetUsersUseCase  │  Business Logic
│  (Use Case)       │
└─────────┬─────────┘
          │ repository.getUsers()
          ▼
┌───────────────────┐
│  UserRepository   │  Abstract Interface
│  (Interface)      │
└─────────┬─────────┘
          │ (implemented by)
          ▼
┌───────────────────┐
│  UserRepoImpl     │  Implementation
│  (Repository)     │
└─────────┬─────────┘
          │ dataSource.getUsers()
          ▼
┌───────────────────┐
│  RemoteDataSource │  API Communication
│  (DataSource)     │
└─────────┬─────────┘
          │ http.get()
          ▼
┌───────────────────┐
│  REST API         │  External Service
│  (Server)         │
└───────────────────┘
```

## 📊 Perbandingan Semua Pertemuan

| Aspek      | P1       | P2       | P3                          | P4                       |
| ---------- | -------- | -------- | --------------------------- | ------------------------ |
| Structure  | Flat     | + Bloc   | + Data Layer                | Clean Architecture       |
| State Mgmt | setState | Cubit    | Cubit                       | Cubit + UseCase          |
| HTTP       | In Page  | In Cubit | In DataSource               | In DataSource            |
| Repository | ❌       | ❌       | ✅ (Interface+Impl in Data) | ✅ (Interface in Domain) |
| Entity     | ❌       | ❌       | ❌                          | ✅                       |
| Use Case   | ❌       | ❌       | ❌                          | ✅                       |
| DI         | ❌       | ❌       | Manual                      | Injector                 |
| Widgets    | In Page  | In Page  | In Page                     | Separate Files           |

## 📚 Konsep Kunci yang Dipelajari

### 1. Dependency Inversion Principle

Domain Layer mendefinisikan interface, Data Layer mengimplementasikan.

### 2. Single Responsibility

- Entity: hanya data
- Use Case: hanya 1 aksi bisnis
- Repository: hanya akses data
- DataSource: hanya komunikasi API

### 3. Separation of Concerns

Setiap layer punya tanggung jawab jelas.

### 4. Dependency Injection

Dependencies dibuat di satu tempat (Injector) dan di-inject ke class yang membutuhkan.

## ✅ Checklist Implementasi Clean Architecture

- [ ] Domain Layer TIDAK import dari Data atau Presentation Layer
- [ ] Use Case menerima Repository Interface (bukan Implementation)
- [ ] Cubit menerima Use Case (bukan Repository langsung)
- [ ] Model extends Entity
- [ ] Semua dependencies dibuat di Injector

## 📝 Latihan untuk Murid

1. Tambahkan fitur Delete User (implementasi di semua layer)
2. Tambahkan fitur Edit User
3. Implementasikan local caching dengan SharedPreferences
4. Tambahkan unit test untuk Use Case

## 🎉 Kesimpulan

Setelah 4 pertemuan, murid telah mempelajari evolusi dari:

- **Kode tanpa struktur** → **Clean Architecture**
- **Sulit di-test** → **Mudah di-test**
- **Sulit di-maintain** → **Mudah di-maintain**
- **Tightly coupled** → **Loosely coupled**
