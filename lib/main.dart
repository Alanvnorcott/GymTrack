//main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'gym_page.dart';
import 'workout_details.dart';
import 'oboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider<DateChangeNotifier>(
      create: (_) => DateChangeNotifier(DateTime.now()),
      child: const WorkoutTrackerApp(),
    ),
  );
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
      home: FutureBuilder<bool>(
        future: _checkOnboardingStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); // Placeholder widget while waiting
          } else {
            final bool showOnboarding = snapshot.data ?? true;
            return showOnboarding
                ? ConcentricAnimationOnboarding()
                : ChangeNotifierProvider(
              create: (_) => DateChangeNotifier(DateTime.now()),
              child: SimpleBottomNavigation(),
            );
          }
        },
      ),
    );
  }
}

Future<bool> _checkOnboardingStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('showOnboarding') ?? true;
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
    final dateChangeNotifier = Provider.of<DateChangeNotifier>(context, listen: false);
    _selectedDate = dateChangeNotifier.date;
    _workoutsMap = {};
    _pages = [
      HomePage(selectedDate: _selectedDate, workoutsMap: _workoutsMap),
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
        selectedItemColor: const Color(0xffe85d04),
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

class DateChangeNotifier extends ChangeNotifier {
  DateTime _date;

  DateChangeNotifier(this._date);

  DateTime get date => _date;

  set date(DateTime newDate) {
    _date = newDate;
    notifyListeners();
  }
}
