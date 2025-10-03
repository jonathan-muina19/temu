import 'package:equatable/equatable.dart';
import 'package:temu/data/models/user_model.dart';

//but : Definir ce qu'on veut faire, pas comment.
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Evenement de type initialisation
class AuthInitial extends AuthState {}

/// Evenement de type chargement
class AuthLoading extends AuthState {}

/// Evenement de type succès
class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];

}

/// Evenement de type email envoyé
class EmailVerificationSent extends AuthState {}

/// Evenement de type email non vérifié
class AuthEmailNotVerified extends AuthState {}

/// Evenement de type email vérifié
class AuthEmailVerified extends AuthState {}

/// Evenement de type échec
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
