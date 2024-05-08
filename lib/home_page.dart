// home_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_page.dart';
import 'workout_select.dart';
import 'workout_details.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<DateTime, Map<String, List<Workout>>> workoutsMap;

  HomePage({required this.selectedDate, required this.workoutsMap});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime selectedDate;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    _loadWorkoutsFromDatabase();
  }

  Future<void> _loadWorkoutsFromDatabase() async {
    final workouts = await _databaseHelper.getAllWorkouts();
    Map<DateTime, Map<String, List<Workout>>> loadedWorkoutsMap = {};

    for (final workout in workouts) {
      final date = DateTime(workout.date.year, workout.date.month, workout.date.day);
      final category = workout.name;
      if (!loadedWorkoutsMap.containsKey(date)) {
        loadedWorkoutsMap[date] = {
          'Weight Training': [],
          'Calisthenics': [],
          'Cardio': [],
          'Other': [],
        };
      }
      loadedWorkoutsMap[date]?[category]?.add(workout);
    }

    setState(() {
      // Assign the loaded workouts map to the widget's workoutsMap
      widget.workoutsMap.clear();
      widget.workoutsMap.addAll(loadedWorkoutsMap);
    });
  }


  Future<void> _saveWorkoutsToDatabase() async {
    for (final entry in widget.workoutsMap.entries) {
      final date = entry.key;
      final workouts = entry.value.values.expand((element) => element).toList();
      await _databaseHelper.updateWorkouts(date, workouts);
    }
  }

  void _addWorkout(Workout workout, String category) {
    setState(() {
      if (!widget.workoutsMap.containsKey(selectedDate)) {
        widget.workoutsMap[selectedDate] = {
          'Weight Training': [],
          'Calisthenics': [],
          'Cardio': [],
          'Other': [],
        };
      }

      // Add the workout to the respective category
      widget.workoutsMap[selectedDate]?[category]?.add(workout);

      // Save the workouts to the database
      _saveWorkoutsToDatabase();
    });
  }



  void _deleteWorkout(Workout workout) {
    setState(() {
      for (final workouts in widget.workoutsMap.values) {
        for (final category in workouts.values) {
          category.removeWhere((w) => w == workout);
        }
      }
      _saveWorkoutsToDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: Icon(Icons.calendar_month_outlined),
          onPressed: () async {
            final DateTime? selectedDate = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarPage(
                  onDateSelected: (selectedDate) {
                    setState(() {
                      this.selectedDate = selectedDate;
                    });
                  },
                  workoutsMap: widget.workoutsMap,
                ),
              ),
            );

            if (selectedDate != null) {
              setState(() {
                this.selectedDate = selectedDate;
              });
            }
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateSelector(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your Workouts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: widget.workoutsMap[selectedDate]?.keys.map((title) {
                return WorkoutSection(
                  title: title,
                  workouts: widget.workoutsMap[selectedDate]?[title] ?? [],
                  onAddWorkout: _addWorkout,
                  onDeleteWorkout: _deleteWorkout,
                );
              }).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateSelector() {
    final now = DateTime.now();
    return SizedBox(
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(30, (index) {
            final day = DateTime(now.year, now.month, now.day + index);
            final dayOfWeek = DateFormat('E').format(day)[0];
            final isSelected = day.day == selectedDate.day;

            if (!widget.workoutsMap.containsKey(day)) {
              widget.workoutsMap[day] = {
                'Weight Training': [],
                'Calisthenics': [],
                'Cardio': [],
                'Other': [],
              };
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = day;
                  });
                },
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
                        color: isSelected ? const Color(0xffe85d04) : Colors.transparent,
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
  final String title;
  final List<Workout> workouts;
  final Function(Workout, String) onAddWorkout; // Modify to accept both arguments
  final Function(Workout) onDeleteWorkout;

  const WorkoutSection({
    Key? key,
    required this.title,
    required this.workouts,
    required this.onAddWorkout,
    required this.onDeleteWorkout,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(color: Color(0xffe85d04), fontSize: 18),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddWorkoutModal(context, widget.title); // Pass category here
                },
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        if (widget.workouts.isNotEmpty)
          Column(
            children: widget.workouts.map((workout) {
              return ListTile(
                key: ValueKey(workout),
                title: Row(
                  children: [
                    Expanded(child: Text(workout.name)),
                    SizedBox(width: 16),
                    Text('Reps: ${workout.reps}, Sets: ${workout.sets}'),
                    IconButton(
                      icon: Icon(Icons.remove_outlined),
                      onPressed: () {
                        widget.onDeleteWorkout(workout);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }


  void _showAddWorkoutModal(BuildContext context, String category) { // Accept category parameter
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
                      intensity: 0,
                      date: DateTime.now(),
                    );
                    widget.onAddWorkout(workout, category); // Pass both workout and category here
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
  }
}
