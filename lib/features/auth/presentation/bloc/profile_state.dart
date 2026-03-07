import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final ProfileEntity profile; // Đảm bảo thuộc tính này tồn tại

  const ProfileLoadSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileLoadFailure extends ProfileState {
  final String message;
  const ProfileLoadFailure(this.message);
}