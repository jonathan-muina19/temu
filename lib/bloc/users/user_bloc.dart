import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/bloc/users/user_events.dart';
import 'package:temu/bloc/users/user_state.dart';

import '../../data/models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore firestore;

  UserBloc(this.firestore) : super(UserInitial()) {
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final doc = await firestore.collection("users").doc(event.uid).get();

      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!, event.uid);
        emit(UserLoaded(user));
      } else {
        emit(UserFaillure(message: "Utilisateur non trouve"));
      }
    } catch (e) {
      emit(UserFaillure(message: "$e"));
    }
  }
}
