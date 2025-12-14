import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/city_entity.dart';

/// State untuk UserCubit
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// State initial/loading
class UserInitial extends UserState {}

/// State loading data
class UserLoading extends UserState {}

/// State ketika data berhasil di-load
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

  /// Method untuk copy state dengan perubahan
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
