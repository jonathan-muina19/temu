import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/bloc/auth/auth_bloc.dart';
import 'package:temu/bloc/splash/splash_cubit.dart';
import 'package:temu/data/repositories/auth_repository.dart';
import 'package:temu/firebase_options.dart';
import 'package:temu/presentation/router/app_router.dart';
import 'package:temu/presentation/screens/splash_screen.dart';
import 'bloc/auth/auth_event.dart';
import 'data/dataproviders/firebase_auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AuthRepository authRepository = MyAuthProvider();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository)),

        /// ✅ Ajout du SplashCubit ici
        BlocProvider<SplashCubit>(create: (context) => SplashCubit()),
      ],
      child: MyApp(authRepository: authRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  MyApp({super.key, required this.authRepository});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
