import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String name;
  final String address;

  const LocationEntity({required this.name, required this.address});

  @override
  List<Object?> get props => [name, address];
}