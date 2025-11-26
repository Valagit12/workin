import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout.dart';
import '../models/workout_result.dart'; // WorkoutResult, ExerciseSet, Rest

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<WorkoutResult>('workout_results');

    return Scaffold(
      appBar: AppBar(title: Text('${workout.name} history'), centerTitle: true),
      body: ValueListenableBuilder<Box<WorkoutResult>>(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          final results = box.values
              .where((r) => r.id == workout.id)
              .toList()
              .reversed
              .toList(); // latest first

          if (results.isEmpty) {
            return const Center(child: Text('No past workouts yet.'));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];

              final totalSets = result.workout.whereType<ExerciseSet>().length;
              final totalRestMinutes = result.workout
                  .whereType<Rest>()
                  .fold<Duration>(Duration.zero, (sum, r) => sum + r.duration)
                  .inMinutes;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Session ${results.length - index}'),
                  subtitle: Text(
                    'Sets: $totalSets • Rest: ${totalRestMinutes}min',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete this result',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete workout result?'),
                            content: const Text(
                              'This will permanently delete this past result. '
                              'This cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        // Because WorkoutResult extends HiveObject
                        await result.delete();
                        // ValueListenableBuilder will rebuild automatically
                      }
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final List<Widget> children = [];
                        String? currentExercise;

                        for (final obj in result.workout) {
                          if (obj is ExerciseSet) {
                            if (currentExercise != obj.exercise) {
                              if (currentExercise != null) {
                                children.add(const Divider());
                              }
                              currentExercise = obj.exercise;
                              children.add(
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    currentExercise!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }

                            children.add(
                              ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.fitness_center,
                                  size: 18,
                                ),
                                title: Text(obj.label),
                              ),
                            );
                          } else if (obj is Rest) {
                            children.add(
                              ListTile(
                                dense: true,
                                leading: const Icon(Icons.timer, size: 18),
                                title: Text(obj.label),
                              ),
                            );
                          }
                        }

                        return AlertDialog(
                          title: Text(
                            'Session ${results.length - index} details',
                          ),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              shrinkWrap: true,
                              children: children,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
