import 'package:flutter/material.dart';

import '../../appconstants.dart';
import '../../models/workout.dart';
import '../../screens/workout_screen.dart';
import '../../widgets/home_app_bar.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key, required this.workoutsBox});

  final workoutsBox;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              debugPrint('Add Workout Tapped');
              // final workout = Workout(
              //   id: DateTime.now().millisecondsSinceEpoch.toString(),
              //   name: 'Full Body',
              //   exercises: [
              //     Exercise(name: 'Bench Press', sets: []),
              //     Exercise(name: 'Lateral Raises', sets: []),
              //     Exercise(name: 'Bicep Curls', sets: []),
              //     Exercise(name: 'Calf Raises', sets: []),
              //   ],
              // );
              //
              // final key = await workoutsBox.add(workout);

              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutScreen(workoutKey: key),
                  ),
                );
              }
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  children: [
                    const Text(
                      'Today\'s Training',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    const Text(
                      'What do you want to do?',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
