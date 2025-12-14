import 'package:equatable/equatable.dart';

/// Entity User - representasi data user di domain layer
/// Tidak bergantung pada layer lain
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String city;

  const UserEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  @override
  List<Object?> get props => [id, name, address, email, phoneNumber, city];
}
