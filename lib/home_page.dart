//home_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_page.dart';
import 'workout_select.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: Icon(Icons.calendar_month_outlined),
          onPressed: () {
            // Navigate to the CalendarPage when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateSelector(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Name\'s Workouts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                WorkoutSection(
                  title: 'Weight Training',
                ),
                WorkoutSection(
                  title: 'Calisthenics',
                ),
                WorkoutSection(
                  title: 'Cardio',
                ),
                WorkoutSection(
                  title: 'Other',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dateSelector() {
    final now = DateTime.now();
    return SizedBox(
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(30, (index) {
            final day = DateTime(now.year, now.month, now.day + index);
            final dayOfWeek =
            DateFormat('E').format(day)[0]; // First letter of the day of the week
            final isToday = now.day == day.day; // Check if it's the current day

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Text(
                    dayOfWeek,
                    style: TextStyle(
                      fontSize: 18,
                      color: isToday ? Colors.white : Colors.white.withOpacity(0.7),
                      // Slightly faded color for non-current days
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      // Bold if it's the current day
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday ? const Color(0xffB1DDF1) : Colors.transparent,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        // Text color set to white for all dates
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        // Bold if it's the current day
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class WorkoutSection extends StatelessWidget {
  final String title;

  const WorkoutSection({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(title),
          Spacer(),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkoutSelect()),
              );
            },
          ),
        ],
      ),
    );
  }
}
