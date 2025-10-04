import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(0));

  // Mettre à jour l'index
  void updateIndex(int index) {
    emit(NavigationState(index));
  }
}
