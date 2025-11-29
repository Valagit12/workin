import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nested_overscroll/nested_overscroll.dart';

import '../models/workout.dart';
import '../models/workout_result.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout _workout;

  late List<WorkoutBlock> _blocks;

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;

    _blocks = _workout.exercises
        .map((_) => WorkoutBlock(setsAndReps: []))
        .toList();
  }

  void _addSetToExercise(int exerciseIndex, ExerciseSet set) {
    final block = _blocks[exerciseIndex];
    final updatedBlock = WorkoutBlock(setsAndReps: [...block.setsAndReps, set]);

    setState(() {
      _blocks[exerciseIndex] = updatedBlock;
    });
  }

  void _addRestToExercise(int exerciseIndex, Rest rest) {
    final block = _blocks[exerciseIndex];
    final updatedBlock = WorkoutBlock(
      setsAndReps: [...block.setsAndReps, rest],
    );

    setState(() {
      _blocks[exerciseIndex] = updatedBlock;
    });
  }

  Future<void> _showAddSetDialog(int exerciseIndex) async {
    final exerciseName = _workout.exercises[exerciseIndex];

    final repsController = TextEditingController(text: '8');
    final weightController = TextEditingController(text: '60');
    final rpeController = TextEditingController(text: '7');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Set – $exerciseName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps'),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
              ),
              TextField(
                controller: rpeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'RPE'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final reps = double.tryParse(repsController.text) ?? 0;
    final weight = double.tryParse(weightController.text) ?? 0;
    final rpe = double.tryParse(rpeController.text) ?? 0;

    final set = ExerciseSet(
      reps: reps,
      weight: weight,
      exercise: exerciseName,
      rpe: rpe,
    );

    _addSetToExercise(exerciseIndex, set);
  }

  Future<void> _showAddRestDialog(int exerciseIndex) async {
    final secondsController = TextEditingController(text: '60');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Rest'),
          content: TextField(
            controller: secondsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Rest (seconds)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final seconds = int.tryParse(secondsController.text) ?? 0;
    final rest = Rest(duration: Duration(seconds: seconds));

    _addRestToExercise(exerciseIndex, rest);
  }

  Future<void> _saveWorkoutResult() async {
    final List<WorkoutObject> allObjects = [];
    for (final block in _blocks) {
      allObjects.addAll(block.setsAndReps);
    }

    final result = WorkoutResult(
      id: _workout.id,
      name: _workout.name,
      workout: allObjects,
    );

    final box = Hive.box<WorkoutResult>('workout_results');
    await box.add(result);

    if (!mounted) return;
    Navigator.of(context).pop(); // go back after saving
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _workout.exercises;

    return Scaffold(
      appBar: AppBar(
        title: Text(_workout.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveWorkoutResult,
            icon: const Icon(Icons.save),
            tooltip: 'Save workout result',
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: NestedOverscroll(
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exerciseName = exercises[index];
              final block = _blocks[index];
              final items = block.setsAndReps;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        exerciseName,
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
                          itemCount: items.length,
                          itemBuilder: (context, itemIndex) {
                            final item = items[itemIndex];

                            return ListTile(
                              leading: Icon(
                                item is ExerciseSet
                                    ? Icons.fitness_center
                                    : Icons.timer,
                              ),
                              title: Text(item.label),
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
                                onPressed: () => _showAddSetDialog(index),
                                child: const Text('Add Set'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showAddRestDialog(index),
                                child: const Text('Add Rest'),
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
        ),
      ),
    );
  }
}
