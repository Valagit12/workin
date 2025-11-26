import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:workin/appconstants.dart';

import '../models/workout.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final List<TextEditingController> workoutInputControllers = [
    TextEditingController(),
  ];

  final TextEditingController title = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  bool fixSubmission = false;

  @override
  void dispose() {
    title.dispose();
    for (final c in workoutInputControllers) {
      c.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _addExerciseField() {
    setState(() {
      workoutInputControllers.add(TextEditingController());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final workoutsBox = Hive.box<Workout>('workouts');

    return Scaffold(
      appBar: AppBar(backgroundColor: !fixSubmission ? null : Colors.red),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _dismissKeyboard,
        child: Form(
          child: ListView(
            controller: _scrollController,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                  vertical: AppSpacing.large,
                ),
                child: SizedBox(
                  child: TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Name',
                    ),
                  ),
                ),
              ),

              for (var workoutController in workoutInputControllers)
                Container(
                  margin: const EdgeInsets.all(AppSpacing.small),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.large),
                          height: 100,
                          child: TextFormField(
                            controller: workoutController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Exercise',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            workoutInputControllers.remove(workoutController);
                          });
                        },
                      ),
                    ],
                  ),
                ),

              Container(
                margin: const EdgeInsets.all(AppSpacing.large),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      heroTag: 'secondary-fab',
                      onPressed: _addExerciseField,
                      child: const Icon(Icons.add),
                    ),
                    FloatingActionButton(
                      heroTag: 'main-fab',
                      onPressed: () async {
                        // Close keyboard on submit tap
                        _dismissKeyboard();

                        // Basic validation
                        if (title.text.isEmpty) {
                          setState(() => fixSubmission = true);
                          return;
                        }

                        final List<String> exercises = [];
                        for (var controller in workoutInputControllers) {
                          if (controller.text.isEmpty) {
                            setState(() => fixSubmission = true);
                            return;
                          }
                          exercises.add(controller.text);
                        }

                        await workoutsBox.add(
                          Workout(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            name: title.text,
                            exercises: exercises,
                          ),
                        );

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
