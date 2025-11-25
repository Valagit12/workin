import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workout});

  final Workout workout; // can fields in dart be null and not final?

  @override
  State<StatefulWidget> createState() => _WorkoutScreenState(); // why do it like this?
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout workout;

  @override
  void initState() {
    super.initState();
    workout = widget.workout;
  }

  void _addSetToExercise(int exerciseIndex) {
    final exercise = workout.exercises[exerciseIndex];
    // exercise.sets.add(ExerciseSet(reps: 8, weight: 60, resttime: 90));

    workout.exercises[exerciseIndex] = exercise;
    workout.save();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final exercises = workout.exercises;

    return Scaffold(
      appBar: AppBar(title: Text(workout.name), centerTitle: true),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    exercise,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Exercise ${index + 1} of ${exercises.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const Divider(height: 24),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: exercise.length,
                      itemBuilder: (context, setIndex) {
                        final set = exercise;
                        return ListTile(
                          title: Text(
                            // 'Set ${setIndex + 1} ${set.reps} reps @ ${set.weight}',
                            'Set ',
                          ),
                          // subtitle: Text('Rest: ${set.resttime}'),
                          subtitle: Text('Rest: '),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _addSetToExercise(index),
                            child: const Text('Add Set'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // later open a timer screen dialogue to store rest seconds
                            },
                            child: const Text('Start Rest Timer'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
