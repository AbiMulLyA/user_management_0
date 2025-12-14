# Pertemuan 2: State Management dengan Cubit

## 🎯 Tujuan Pembelajaran

Pada pertemuan ini, murid akan mempelajari:

1. **Cubit/BLoC Pattern**: Memisahkan logic dari UI
2. **State Class**: Merepresentasikan kondisi UI
3. **BlocProvider**: Menyediakan Cubit ke widget tree
4. **BlocBuilder**: Rebuild UI saat state berubah
5. **Equatable**: Perbandingan object yang efisien

## 📁 Struktur Folder

```
pertemuan2/
├── main.dart                 # Entry point dengan BlocProvider
├── bloc/
│   ├── user_cubit.dart       # Logic state management
│   └── user_state.dart       # State classes
├── models/
│   └── user_model.dart       # Model data
├── pages/
│   └── user_list_page.dart   # UI dengan BlocBuilder
└── README.md
```

## 🔄 Perbandingan dengan Pertemuan 1

| Aspek          | Pertemuan 1    | Pertemuan 2          |
| -------------- | -------------- | -------------------- |
| Widget Type    | StatefulWidget | StatelessWidget      |
| State Location | Dalam Page     | Di Cubit             |
| Update UI      | setState()     | emit() + BlocBuilder |
| Logic Location | Dalam Page     | Di Cubit             |
| Testability    | Sulit          | Lebih Mudah          |

## 📚 Materi yang Dibahas

### 1. State Class (user_state.dart)

```dart
abstract class UserState extends Equatable {}

class UserInitial extends UserState {}  // State awal
class UserLoading extends UserState {}  // Sedang loading
class UserLoaded extends UserState {}   // Data berhasil dimuat
class UserError extends UserState {}    // Terjadi error
```

### 2. Cubit (user_cubit.dart)

```dart
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> loadUsers() async {
    emit(UserLoading());      // Mulai loading
    // ... fetch data ...
    emit(UserLoaded(users));  // Selesai, kirim data
  }
}
```

### 3. BlocProvider (main.dart)

```dart
BlocProvider(
  create: (context) => UserCubit(),
  child: const UserListPage(),
)
```

### 4. BlocBuilder (user_list_page.dart)

```dart
BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    if (state is UserLoading) return CircularProgressIndicator();
    if (state is UserLoaded) return ListView(...);
    if (state is UserError) return ErrorWidget(...);
  },
)
```

## ⚠️ Yang Masih Belum Ideal

1. **HTTP Request di Cubit**

   - Cubit masih langsung panggil API
   - Seharusnya ada Repository sebagai perantara

2. **Tidak Ada Separation of Concerns**

   - Data access logic masih di Cubit
   - Cubit seharusnya hanya manage state

3. **Belum Ada Entity**
   - Model dipakai langsung
   - Seharusnya ada Entity di Domain Layer

**Di Pertemuan 3, kita akan tambahkan Data Layer (Repository, DataSource)!**

## 📝 Latihan untuk Murid

1. Tambahkan state `UserEmpty` khusus untuk kondisi list kosong
2. Tambahkan method `searchUsers(String query)` di Cubit
3. Coba extract `_buildUserCard` ke widget terpisah (UserCard)

## 🔗 Dependencies yang Dibutuhkan

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
```
