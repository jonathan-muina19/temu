import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [this.isLoading, this.user, this.error];
}
