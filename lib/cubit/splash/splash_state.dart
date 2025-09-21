import 'package:equatable/equatable.dart';

// Cette enum liste les differentes etats du splash
enum SplashStatus {initial, firstLauch, notFirstLauch}

class SplashState extends Equatable{
  final SplashStatus status;

  SplashState({required this.status});

  @override
  List<Object?> get props => [status];
}


