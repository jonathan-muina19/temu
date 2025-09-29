import 'package:equatable/equatable.dart';

// Cette enum liste les différents états du splash
enum SplashStatus { initial, firstLaunch, notFirstLaunch }

class SplashState extends Equatable {
  final SplashStatus status;

  const SplashState({required this.status});

  // État initial
  factory SplashState.initial() => const SplashState(status: SplashStatus.initial);

  // Permet de copier l'état facilement
  SplashState copyWith({SplashStatus? status}) {
    return SplashState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
