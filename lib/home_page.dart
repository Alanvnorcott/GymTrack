// home_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_page.dart';
import 'workout_select.dart';
import 'workout_details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<Workout>> workoutsMap = {
    'Weight Training': [],
    'Calisthenics': [],
    'Cardio': [],
    'Other': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: Icon(Icons.calendar_month_outlined),
          onPressed: () {
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
              children: workoutsMap.keys.map((title) {
                return WorkoutSection(
                  title: title,
                  workouts: workoutsMap[title]!,
                  onAddWorkout: (workout) {
                    setState(() {
                      workoutsMap[title]!.add(workout);
                    });
                  },
                );
              }).toList(),
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

class WorkoutSection extends StatefulWidget {
  final String title;
  final List<Workout> workouts;
  final Function(Workout) onAddWorkout;

  const WorkoutSection({
    Key? key,
    required this.title,
    required this.workouts,
    required this.onAddWorkout,
  }) : super(key: key);

  @override
  _WorkoutSectionState createState() => _WorkoutSectionState();
}

class _WorkoutSectionState extends State<WorkoutSection> {
  String workoutName = '';
  int reps = 0;
  int sets = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(color: Colors.blue), // Change category color here
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Workout Name:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  workoutName = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter workout name',
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Reps:',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  reps = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Sets:',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  sets = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (workoutName.isNotEmpty && reps > 0 && sets > 0) {
                                  Workout workout = Workout(
                                    name: workoutName,
                                    reps: reps,
                                    sets: sets,
                                    intensity: 0, // Intensity not used in this context
                                  );
                                  widget.onAddWorkout(workout);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        ...widget.workouts.map((workout) {
          return ListTile(
            title: Row(
              children: [
                Expanded(child: Text(workout.name)),
                SizedBox(width: 16),
                Text('Reps: ${workout.reps}, Sets: ${workout.sets}'),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}