import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workin/screens/workout_screen.dart';

import '../appconstants.dart';
import '../models/workout.dart';

class WorkoutcardWidget extends StatelessWidget {
  const WorkoutcardWidget({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: AppSpacing.small),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WorkoutScreen(workout: workout),
              ),
            );
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.small),
            child: Center(
              child: Text(workout.name, style: TextStyle(fontSize: 30)),
            ),
          ),
        ),
      ),
    );
  }
}
