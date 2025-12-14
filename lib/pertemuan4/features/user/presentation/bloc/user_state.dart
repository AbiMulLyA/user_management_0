// ============================================================================
// PERTEMUAN 4: USER STATE - PRESENTATION LAYER
// ============================================================================

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';

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

/// State loaded dengan data lengkap
class UserLoaded extends UserState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final List<CityEntity> cities;
  final String searchQuery;
  final String? selectedCity;
  final bool isAscending;

  const UserLoaded({
    required this.users,
    required this.filteredUsers,
    required this.cities,
    this.searchQuery = '',
    this.selectedCity,
    this.isAscending = true,
  });

  @override
  List<Object?> get props => [
        users,
        filteredUsers,
        cities,
        searchQuery,
        selectedCity,
        isAscending,
      ];

  /// CopyWith untuk immutable state update
  UserLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    List<CityEntity>? cities,
    String? searchQuery,
    String? selectedCity,
    bool? isAscending,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      cities: cities ?? this.cities,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity: selectedCity,
      isAscending: isAscending ?? this.isAscending,
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
