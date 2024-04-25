import 'package:flutter/material.dart';
import 'package:workout_app/pages/exercises_page.dart';
import 'package:workout_app/pages/history_page.dart';
import 'package:workout_app/pages/home_page.dart';
import 'package:workout_app/pages/settings_page.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List _pages = [
    const HomePage(),
    const HistoryPage(),
    const ExercisesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: navigateBottomBar,
      ),
      body: _pages[selectedIndex],
    );
  }
}
