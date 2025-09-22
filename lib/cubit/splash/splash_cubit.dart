import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temu/cubit/splash/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit()
    : super(SplashState(status: SplashStatus.initial)); // On demare le spash

  // Cette methode est asynchrone car on va attendre le timer
  // Elle sera appelee depuis le initial() du splashscreen
  Future<void> checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 4)); // Timer du splash

    // On cree une instance de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (onboardingDone) {
      emit(SplashState(status: SplashStatus.notFirstLauch));
    } else {
      emit(SplashState(status: SplashStatus.firstLauch));
    }
  }
}
