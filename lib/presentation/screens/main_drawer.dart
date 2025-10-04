import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu/presentation/screens/navigationBarScreens/categories.dart';
import 'package:temu/presentation/screens/navigationBarScreens/favoris.dart';
import 'package:temu/presentation/screens/navigationBarScreens/home.dart';
import 'package:temu/presentation/screens/navigationBarScreens/profil.dart';
import '../../bloc/navigation/navigation_cubit.dart';
import '../../bloc/navigation/navigation_state.dart';
import 'home_screen.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      HomePage(),
      CategoriesPage(),
      FavorisPage(),
      HomeScreen()
    ];

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: screens[state.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.selectedIndex,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold
                ),
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: (index) =>
                    context.read<NavigationCubit>().updateIndex(index),
                items:  [
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/maison.png", height: 20),
                    label: 'Accueil',
                    activeIcon: Image.asset("assets/icons/maison (1).png", height: 20)
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/categorie.png", height: 20),
                    label: 'Catégories',
                    activeIcon: Image.asset("assets/icons/categorie (1).png", height: 20)
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/coeur (1).png", height: 20),
                    label: 'Favoris',
                   activeIcon: Image.asset("assets/icons/coeur (2).png", height: 20)
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/utilisateur.png", height: 20),
                    label: 'Profil',
                    activeIcon: Image.asset("assets/icons/utilisateur (1).png", height: 20)
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
