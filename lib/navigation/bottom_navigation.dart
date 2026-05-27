import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/presentation/screens/profile.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/navigation/navigation_state.dart';
import '../presentation/screens/favourite/favourite_page.dart';
import '../presentation/screens/vehicle/explore_page.dart';
import '../presentation/screens/vehicle/home_page.dart';


class NavigPage extends StatelessWidget {
  const NavigPage({super.key});

  final List<Widget> pages = const [
    HomePage(),
    ExplorePage(),
    FavoritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        return Scaffold(
          // Display the page corresponding to the current BLoC state index
          body: pages[state.index],

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF0E0F13),
            type: BottomNavigationBarType.fixed, // Necessary for 4+ items
            currentIndex: state.index,
            selectedItemColor: Colors.deepPurpleAccent,
            unselectedItemColor: Colors.white70,

            onTap: (index) {
              // Dispatch event to BLoC
              context.read<NavBloc>().add(TabChanged(index));
            },

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}