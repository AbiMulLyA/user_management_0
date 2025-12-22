// ============================================================================
// PERTEMUAN 2: USER STATE - REPRESENTASI KONDISI UI
// ============================================================================
//
// 🆕 FILE BARU DI PERTEMUAN 2!
// ============================================================================
// File ini TIDAK ADA di Pertemuan 1.
//
// Di Pertemuan 1, state direpresentasikan dengan variabel terpisah:
//   bool isLoading = false;
//   String? errorMessage;
//   List<UserModel> users = [];
//
// Di Pertemuan 2, kita buat class khusus untuk setiap kondisi state:
//   UserInitial  → kondisi awal
//   UserLoading  → menggantikan isLoading = true
//   UserLoaded   → menggantikan users = [...]
//   UserError    → menggantikan errorMessage = "..."
//
// KEUNTUNGAN:
// - Lebih jelas dan type-safe
// - Tidak mungkin state tidak konsisten
// - Mudah di-test
//
// ============================================================================

import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

// =============================================================================
// PENJELASAN EQUATABLE - DENGAN ANALOGI 🎓
// =============================================================================
//
// 🤔 APA ITU EQUATABLE?
// ---------------------
// Equatable adalah package yang membantu membandingkan dua objek berdasarkan
// ISI/VALUE-nya, bukan berdasarkan ALAMAT MEMORI-nya.
//
// 📦 ANALOGI: PAKET PENGIRIMAN
// -----------------------------
// Bayangkan kamu punya 2 paket pengiriman:
//   - Paket A: berisi buku "Harry Potter", dikirim dari Jakarta
//   - Paket B: berisi buku "Harry Potter", dikirim dari Surabaya
//
// TANPA Equatable (perbandingan default Dart):
//   → Dart melihat: "Ini paket berbeda! Satu dari Jakarta, satu dari Surabaya"
//   → Paket A == Paket B? FALSE ❌ (padahal isinya sama!)
//
// DENGAN Equatable:
//   → Equatable melihat: "Isi paketnya sama, yaitu buku Harry Potter"
//   → Paket A == Paket B? TRUE ✅ (yang penting isinya sama!)
//
// 🏠 ANALOGI LAIN: RUMAH DENGAN ALAMAT
// ------------------------------------
// - Tanpa Equatable: "Rumah di Jl. A No.1" ≠ "Rumah di Jl. A No.1"
//   (Dart melihat ini sebagai 2 rumah berbeda meski alamatnya sama)
//
// - Dengan Equatable: "Rumah di Jl. A No.1" == "Rumah di Jl. A No.1"
//   (Equatable melihat alamatnya sama, berarti rumah yang sama!)
//
// 🎯 KENAPA PENTING UNTUK BLOC?
// -----------------------------
// BLoC perlu tahu apakah state BENAR-BENAR berubah atau tidak.
// Jika state sama → UI tidak perlu rebuild (hemat baterai & performa)
// Jika state beda → UI perlu rebuild (tampilkan data baru)
//
// Contoh:
//   State lama: UserLoaded(users: [Abi, Budi])
//   State baru: UserLoaded(users: [Abi, Budi])
//
//   Tanpa Equatable → BLoC: "State berbeda!" → Rebuild UI (BOROS!) 😰
//   Dengan Equatable → BLoC: "State sama!" → Skip rebuild (HEMAT!) 😎
//
// =============================================================================

// =============================================================================
// PENJELASAN PROPS - DENGAN ANALOGI 🎓
// =============================================================================
//
// 🤔 APA ITU PROPS?
// -----------------
// "props" adalah singkatan dari "properties" (properti/atribut).
// Props adalah DAFTAR hal-hal yang ingin kita bandingkan.
//
// 🪪 ANALOGI: KTP (KARTU TANDA PENDUDUK)
// --------------------------------------
// Bayangkan kamu ingin membandingkan 2 orang apakah sama atau tidak.
// props adalah KRITERIA yang kamu gunakan untuk membandingkan.
//
// Contoh 1: props => [nik]
//   → "Bandingkan berdasarkan NIK saja"
//   → Orang dengan NIK sama = orang yang sama
//
// Contoh 2: props => [nama, tanggalLahir, alamat]
//   → "Bandingkan berdasarkan nama, tanggal lahir, DAN alamat"
//   → Semua harus sama baru dianggap orang yang sama
//
// 🛒 ANALOGI: STRUK BELANJA
// -------------------------
// props => [items, totalHarga]
//
// Struk 1: items=[Indomie, Teh], total=15000
// Struk 2: items=[Indomie, Teh], total=15000
// → SAMA! ✅ (props-nya identik)
//
// Struk 3: items=[Indomie, Kopi], total=20000
// → BEDA! ❌ (props-nya berbeda)
//
// 📋 PROPS KOSONG: props => []
// ----------------------------
// Artinya: "Tidak ada yang perlu dibandingkan"
// Digunakan untuk state yang tidak punya data (seperti UserInitial, UserLoading)
//
// Ibarat: Membandingkan 2 kertas kosong
// → Keduanya sama-sama kosong = SAMA! ✅
//
// =============================================================================

// =============================================================================
// BASE STATE CLASS
// =============================================================================

/// Base class untuk semua state
///
/// 🎓 ANALOGI: Ini seperti "CETAKAN DASAR" untuk semua jenis state.
/// Semua state (Initial, Loading, Loaded, Error) dibuat dari cetakan ini.
abstract class UserState extends Equatable {
  const UserState();

  /// 🎓 PROPS KOSONG untuk base class
  ///
  /// Kenapa kosong []? Karena base class ini tidak punya data apapun.
  /// Ibarat: Template kosong yang belum diisi.
  ///
  /// Class turunan (seperti UserLoaded, UserError) akan meng-override
  /// props ini dengan data yang mereka punya.
  @override
  List<Object?> get props => [];
}

// =============================================================================
// STATE: Initial
// =============================================================================

/// State awal sebelum ada aksi apapun
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini adalah kondisi ketika:
/// - users = [] (kosong)
/// - isLoading = false
/// - errorMessage = null
class UserInitial extends UserState {}

// =============================================================================
// STATE: Loading
// =============================================================================

/// State ketika sedang memuat data
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini menggantikan: isLoading = true
class UserLoading extends UserState {}

// =============================================================================
// STATE: Loaded (Success)
// =============================================================================

/// State ketika data berhasil dimuat
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini menggantikan:
/// - users = [...] (data dari API)
/// - isLoading = false
/// - errorMessage = null
class UserLoaded extends UserState {
  /// Daftar user dari API
  /// 📌 DULU: variabel 'users' di _UserListPageState
  final List<UserModel> users;

  const UserLoaded({required this.users});

  /// 🎓 PROPS BERISI [users]
  ///
  /// Artinya: "Bandingkan state ini berdasarkan DAFTAR USERS-nya"
  ///
  /// 🛒 ANALOGI: Keranjang Belanja
  /// - Keranjang A: [Indomie, Teh, Roti]
  /// - Keranjang B: [Indomie, Teh, Roti]
  /// → props sama? YA! → State dianggap SAMA ✅
  ///
  /// - Keranjang C: [Indomie, Kopi]
  /// → props beda? YA! → State dianggap BERBEDA ❌ → Rebuild UI
  ///
  /// Jadi kalau list users tidak berubah, BLoC tidak akan rebuild UI.
  /// Ini HEMAT performa! 🚀
  @override
  List<Object?> get props => [users];
}

// =============================================================================
// STATE: Error
// =============================================================================

/// State ketika terjadi error
///
/// 📌 MAPPING DARI PERTEMUAN 1:
/// Ini menggantikan:
/// - errorMessage = "..." (ada error)
/// - isLoading = false
class UserError extends UserState {
  /// Pesan error
  /// 📌 DULU: variabel 'errorMessage' di _UserListPageState
  final String message;

  const UserError({required this.message});

  /// 🎓 PROPS BERISI [message]
  ///
  /// Artinya: "Bandingkan state ini berdasarkan PESAN ERROR-nya"
  ///
  /// 📱 ANALOGI: Notifikasi Error di HP
  /// - Error A: "Tidak ada koneksi internet"
  /// - Error B: "Tidak ada koneksi internet"
  /// → props sama? YA! → State dianggap SAMA ✅ → Tidak perlu rebuild
  ///
  /// - Error C: "Server sedang maintenance"
  /// → props beda? YA! → State dianggap BERBEDA ❌ → Rebuild UI dengan pesan baru
  ///
  /// Ini berguna agar error yang sama tidak ditampilkan ulang terus-menerus.
  @override
  List<Object?> get props => [message];
}
