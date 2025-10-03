import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable{
  @override
  /// retourne une liste vide
  /// car cette classe n'a pas de propriété spécifique.
  List<Object?> get props => [];
}

class LoadUserData extends UserEvent{
  final String uid;

  LoadUserData(this.uid);

  List<Object?> get props => [this.uid];
}