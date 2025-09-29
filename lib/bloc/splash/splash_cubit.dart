import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temu/bloc/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial()); // état initial propre

  /// Vérifie si l'app est lancée pour la première fois
  Future<void> checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 4)); // Timer du splash

    final prefs = await SharedPreferences.getInstance();

    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (onboardingDone) {
      emit(state.copyWith(status: SplashStatus.notFirstLaunch));
    } else {
      emit(state.copyWith(status: SplashStatus.firstLaunch));
    }
  }
}
