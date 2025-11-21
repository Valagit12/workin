import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/workout.dart';
import '../screens/workout_screen.dart';

class AddWorkoutButton extends StatelessWidget {
  const AddWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutsBox = Hive.box<Workout>('workouts');
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          debugPrint('Add Workout Tapped');
          final workout = Workout(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'Full Body',
            exercises: [
              Exercise(name: 'Bench Press', sets: []),
              Exercise(name: 'Lateral Raises', sets: []),
              Exercise(name: 'Bicep Curls', sets: []),
              Exercise(name: 'Calf Raises', sets: []),
            ],
          );

          final key = await workoutsBox.add(workout);

          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => WorkoutScreen(workoutKey: key)),
            );
          }
        },
      ),
    );
  }
}
