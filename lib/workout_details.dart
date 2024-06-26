// workout_details.dart

import 'package:flutter/material.dart';

class WorkoutDetails extends StatefulWidget {
  final String workoutName;
  final DateTime date;
  final Function(Workout) onAddWorkout;

  const WorkoutDetails({
    Key? key,
    required this.workoutName,
    required this.date,
    required this.onAddWorkout,
  }) : super(key: key);

  @override
  _WorkoutDetailsState createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  int reps = 0;
  int sets = 0;
  double intensity = 3.0;
  double weight = 0.0; // Add weight variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details - ${widget.workoutName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reps:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    reps = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sets:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    sets = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Intensity:',
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              value: intensity,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  intensity = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Weight:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    weight = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (widget.workoutName.isNotEmpty &&
                      reps > 0 &&
                      sets > 0 &&
                      weight > 0.0) {
                    Workout workout = Workout(
                      name: widget.workoutName,
                      reps: reps,
                      sets: sets,
                      intensity: intensity,
                      date: widget.date,
                      weightInKg: weight,
                      weightInLb: weight * 2.20462,
                    );
                    widget.onAddWorkout(workout);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Workout {
  final String name;
  final int reps;
  final int sets;
  final double intensity;
  final DateTime date;
  final double weightInKg;
  final double weightInLb;

  Workout({
    required this.name,
    required this.reps,
    required this.sets,
    required this.intensity,
    required this.date,
    required this.weightInKg,
    required this.weightInLb,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'reps': reps,
      'sets': sets,
      'intensity': intensity,
      'date': date.toIso8601String(),
      'weightInKg': weightInKg,
      'weightInLb': weightInLb,
    };
  }
}
