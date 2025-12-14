# Pertemuan 1: Flutter Basic - Tanpa Clean Architecture

## 🎯 Tujuan Pembelajaran

Pada pertemuan ini, murid akan mempelajari:

1. **Dasar Flutter**: MaterialApp, Scaffold, AppBar
2. **StatefulWidget**: Lifecycle (initState, setState)
3. **HTTP Request**: Package http, GET request
4. **JSON Parsing**: json.decode, model class dengan fromJson
5. **UI State Management Manual**: isLoading, errorMessage, data

## 📁 Struktur Folder

```
pertemuan1/
├── main.dart              # Entry point aplikasi
├── models/
│   └── user_model.dart    # Model untuk data user
├── pages/
│   └── user_list_page.dart # Halaman utama (semua logic di sini!)
└── README.md              # File ini
```

## 🚀 Cara Menjalankan

1. Copy folder `pertemuan1` ke project Flutter baru
2. Pastikan `pubspec.yaml` memiliki dependency:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     http: ^1.1.0
   ```
3. Ubah `lib/main.dart` menjadi:
   ```dart
   export 'pertemuan1/main.dart';
   ```
   Atau copy isi `pertemuan1/main.dart` ke `lib/main.dart`
4. Run: `flutter run`

## 📚 Materi yang Dibahas

### 1. Entry Point (main.dart)

- Fungsi `main()` dan `runApp()`
- MaterialApp dan ThemeData
- Widget tree dasar

### 2. Model (user_model.dart)

- Class dengan properties
- Constructor dengan named parameters
- Factory constructor `fromJson()`
- Null safety dengan `??`

### 3. StatefulWidget (user_list_page.dart)

- Perbedaan StatelessWidget vs StatefulWidget
- State variables: `users`, `isLoading`, `errorMessage`
- Lifecycle: `initState()` untuk inisialisasi
- `setState()` untuk update UI

### 4. HTTP Request

- Package `http`
- `http.get()` untuk GET request
- Status code handling
- Error handling dengan try-catch

### 5. JSON Parsing

- `json.decode()` untuk parse response
- Konversi List<dynamic> ke List<Model>
- `map()` dan `toList()`

### 6. UI Conditional

- Menampilkan widget berbeda berdasarkan state
- Loading indicator
- Error state dengan retry button
- Empty state
- Data list dengan ListView.builder

## ⚠️ Masalah yang Akan Dibahas di Pertemuan Selanjutnya

Kode di pertemuan ini **sengaja** dibuat tidak ideal untuk menunjukkan masalah:

1. **Semua Logic di UI**

   - HTTP request ada di dalam widget
   - Business logic campur dengan UI
   - Sulit untuk testing

2. **Tidak Ada Separation of Concerns**

   - Satu file menangani banyak hal
   - Sulit untuk maintenance

3. **Hardcoded Values**

   - URL API langsung ditulis di kode
   - Tidak ada file config

4. **Tidak Reusable**
   - Widget card tidak bisa digunakan di tempat lain
   - Logic fetch tidak bisa di-share

**Di pertemuan 2, kita akan mulai refactor menggunakan Clean Architecture!**

## 📝 Latihan untuk Murid

1. Coba tambahkan tombol FAB untuk "Add User" (UI saja, belum fungsional)
2. Coba ubah warna tema aplikasi
3. Coba tambahkan field baru di UserModel (misal: avatar URL)
4. Coba buat loading skeleton sederhana

## 🔗 API yang Digunakan

- Base URL: `https://627e360ab75a25d3f3b37d5a.mockapi.io/api/v1/accurate`
- Endpoint: `/user`
- Method: GET
