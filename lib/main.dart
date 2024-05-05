//main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'gym_page.dart';
import 'workout_details.dart';

void main() {
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6200ee),
          brightness: Brightness.dark,
        ),
      ),
      home: SimpleBottomNavigation(),
    );
  }
}

class SimpleBottomNavigation extends StatefulWidget {
  const SimpleBottomNavigation({Key? key}) : super(key: key);

  @override
  State<SimpleBottomNavigation> createState() => _SimpleBottomNavigationState();
}

class _SimpleBottomNavigationState extends State<SimpleBottomNavigation> {
  int _selectedIndex = 0;
  late DateTime _selectedDate; // Declare selected date variable

  late Map<DateTime, Map<String, List<Workout>>> _workoutsMap; // Declare workoutsMap variable

  late List<Widget> _pages; // Declare pages variable

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Initialize selected date
    _workoutsMap = {}; // Initialize workoutsMap
    _pages = [
      HomePage(selectedDate: _selectedDate, workoutsMap: _workoutsMap), // Pass selected date and workoutsMap to HomePage
      GymPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffB1DDF1),
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navBarItems,
      ),
    );
  }
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.map_outlined),
    activeIcon: Icon(Icons.map_outlined),
    label: 'Gyms',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
];
