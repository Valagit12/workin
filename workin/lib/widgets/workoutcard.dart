import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workin/screens/add_workout_screen.dart';
import 'package:workin/screens/workout_history_screen.dart';
import 'package:workin/screens/workout_screen.dart';

import '../appconstants.dart';
import '../models/workout.dart';
import '../models/workout_result.dart';

class WorkoutcardWidget extends StatelessWidget {
  const WorkoutcardWidget({super.key, required this.workout});

  final Workout workout;

  Future<void> _deleteWorkout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete workout?'),
          content: Text(
            'This will delete "${workout.name}". '
            'All saved results for this workout will also be removed. '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final resultsBox = Hive.box<WorkoutResult>('workout_results');
    final resultsToDelete = resultsBox.values
        .where((r) => r.id == workout.id)
        .toList();
    for (final r in resultsToDelete) {
      await r.delete();
    }

    await workout.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => WorkoutScreen(workout: workout)),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.small),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    workout.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),

                Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete workout',
                    onPressed: () => _deleteWorkout(context),
                  ),
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit workout',
                        onPressed: () {
                          final resultBox = Hive.box<WorkoutResult>(
                            'workout_results',
                          );
                          bool newWorkout = false;
                          if (resultBox.values.any(
                            (row) => row.id == workout.id,
                          )) {
                            debugPrint('new workout');
                            newWorkout = true;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddWorkoutScreen(
                                workout: workout,
                                newWorkout: newWorkout,
                              ),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.history),
                        tooltip: 'View past workouts',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkoutHistoryScreen(workout: workout),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
