//but : Definir ce qu'on veut faire, pas comment.

import 'package:equatable/equatable.dart';
import 'package:temu/data/models/user_model.dart';

abstract class UserState extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState{}

class UserLoading extends UserState{}

class UserLoaded extends UserState{
  final UserModel user;

  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];

}

class UserFaillure extends UserState{
  final String message;

  UserFaillure({required this.message});

  @override
  List<Object?> get props => [message];
}
