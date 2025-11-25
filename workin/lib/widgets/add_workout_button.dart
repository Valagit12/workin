import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:workin/screens/add_workout_screen.dart';

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
          if (context.mounted) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => AddWorkoutScreen()));
          }
        },
      ),
    );
  }
}
