// ============================================================================
// PERTEMUAN 3: USER STATE - DENGAN CITIES DAN FILTER
// ============================================================================

import 'package:equatable/equatable.dart';
import '../data/models/user_model.dart';
import '../data/models/city_model.dart';

/// Base class untuk semua state
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// State awal
class UserInitial extends UserState {}

/// State loading
class UserLoading extends UserState {}

/// State loaded dengan data users dan cities
class UserLoaded extends UserState {
  /// Semua user dari API
  final List<UserModel> users;

  /// User yang ditampilkan (setelah filter)
  final List<UserModel> filteredUsers;

  /// Daftar kota untuk dropdown
  final List<CityModel> cities;

  /// Query pencarian
  final String searchQuery;

  /// Kota yang dipilih untuk filter
  final String? selectedCity;

  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    required this.cities,
    this.searchQuery = '',
    this.selectedCity,
  });

  @override
  List<Object?> get props =>
      [users, filteredUsers, cities, searchQuery, selectedCity];

  /// CopyWith untuk buat state baru dengan beberapa perubahan
  UserLoaded copyWith({
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
    List<CityModel>? cities,
    String? searchQuery,
    String? selectedCity,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      cities: cities ?? this.cities,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity: selectedCity,
    );
  }
}

/// State error
class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
