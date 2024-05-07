//workout_select.dart

import 'package:flutter/material.dart';
import 'workout_details.dart'; // Import the WorkoutDetails widget

class WorkoutSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Select'),
      ),
      body: ListView(
        children: [
          WorkoutListItem(
            workoutName: 'Pushups',
          ),
          WorkoutListItem(
            workoutName: 'Squats',
          ),
          WorkoutListItem(
            workoutName: 'Pull-ups',
          ),
          // Add more workouts as needed
        ],
      ),
    );
  }
}

class WorkoutListItem extends StatelessWidget {
  final String workoutName;

  const WorkoutListItem({
    Key? key,
    required this.workoutName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(workoutName),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          // Navigate to the WorkoutDetails page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutDetails(
              workoutName: workoutName,
              onAddWorkout: (workout) {
                // Handle adding the workout to the corresponding category on the home page
                // You can implement this logic here or in the home page
                // For now, you can print the workout details
                print('Added workout: $workout');
              },
              date: DateTime.now(), // Provide a default value for date
            )),
          );
        },
      ),
    );
  }
}
