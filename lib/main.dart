import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/cubit/auth/auth_cubit.dart';
import 'package:temu/data/repositories/auth_repository.dart';
import 'package:temu/firebase_options.dart';
import 'package:temu/presentation/router/app_router.dart';
import 'package:temu/presentation/screens/splash_screen.dart';
import 'data/dataproviders/firebase_auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1️⃣ Créer le provider
  final authProvider = MyAuthProvider();

  // 2️⃣ Créer le repository en passant le provider
  final authRepository = AuthRepository(authProvider);

  runApp(MyApp(authRepository: authRepository));
  // <-- Ici, on passe le repository au widget MyApp et non pas le provider
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  MyApp({super.key, required this.authRepository});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(authRepository)..checkAuthStatus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
