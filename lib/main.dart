import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'gym_page.dart';

void main() {
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
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

  final List<Widget> _pages = [
    HomePage(), // Replace with your Home page
    CalendarPage(), // Assuming you have a CalendarPage class
    GymPage(), // Replace with your Gyms page
    ProfilePage(), // Assuming you have a ProfilePage class
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitTrack')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
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
    icon: Icon(Icons.calendar_month_outlined),
    activeIcon: Icon(Icons.calendar_month_outlined),
    label: 'Calendar',
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