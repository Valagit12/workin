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

  bool fixSubmission = false;

  @override
  Widget build(BuildContext context) {
    final workoutsBox = Hive.box<Workout>('workouts');

    return Scaffold(
      appBar: AppBar(backgroundColor: !fixSubmission ? null : Colors.red),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'secondary-fab',
              child: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  workoutInputControllers.add(TextEditingController());
                });
              },
            ),
            FloatingActionButton(
              heroTag: 'main-fab',
              onPressed: () async {
                List<String> exercises = [];
                for (var controller in workoutInputControllers) {
                  if (controller.text.isEmpty) {
                    setState(() {
                      fixSubmission = true;
                    });
                    return;
                  }
                  exercises.add(controller.text);
                }

                await workoutsBox.add(
                  Workout(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: title.text,
                    exercises: exercises,
                  ),
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(Icons.check),
            ),
          ],
        ),
      ),
      body: Form(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppSpacing.large,
                vertical: AppSpacing.large,
              ),
              child: SizedBox(
                child: TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name',
                  ),
                ),
              ),
            ),

            for (var workoutController in workoutInputControllers)
              Container(
                margin: EdgeInsets.all(AppSpacing.small),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.large),
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
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          workoutInputControllers.remove(workoutController);
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
