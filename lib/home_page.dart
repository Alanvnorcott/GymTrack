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
  // Map to store workouts for each date
  Map<DateTime, Map<String, List<Workout>>> workoutsMap = {};

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
              children: workoutsMap.entries.map((entry) {
                final date = entry.key;
                final workoutData = entry.value;
                return WorkoutSection(
                  date: date,
                  workoutsMap: workoutData,
                  onAddWorkout: (workout) {
                    setState(() {
                      if (!workoutsMap.containsKey(date)) {
                        workoutsMap[date] = {};
                      }
                      workoutsMap[date]![workout.category] ??= [];
                      workoutsMap[date]![workout.category]!.add(workout);
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

  DateTime selectedDate = DateTime.now(); // Initialize selected date to today

  Widget dateSelector() {
    final now = DateTime.now();
    return SizedBox(
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(30, (index) {
            final day = DateTime(now.year, now.month, now.day + index);
            final dayOfWeek = DateFormat('E').format(day)[0];
            final isSelected = selectedDate.day == day.day;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = day;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(
                      dayOfWeek,
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color(0xffB1DDF1) : Colors.transparent,
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class WorkoutSection extends StatefulWidget {
  final DateTime date;
  final Map<String, List<Workout>> workoutsMap;
  final Function(Workout) onAddWorkout;

  const WorkoutSection({
    Key? key,
    required this.date,
    required this.workoutsMap,
    required this.onAddWorkout,
  }) : super(key: key);

  @override
  _WorkoutSectionState createState() => _WorkoutSectionState();
}

class _WorkoutSectionState extends State<WorkoutSection> {
  String workoutName = '';
  int reps = 0;
  int sets = 0;
  String category = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Workouts for ${DateFormat('MMM d, yyyy').format(widget.date)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...widget.workoutsMap.entries.map((entry) {
          final category = entry.key;
          final workouts = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  category,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              ...workouts.map((workout) {
                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text('Reps: ${workout.reps}, Sets: ${workout.sets}'),
                );
              }).toList(),
            ],
          );
        }).toList(),
        ListTile(
          title: Text('Add Workout'),
          onTap: () {
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
                              category: category,
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
    );
  }
}
