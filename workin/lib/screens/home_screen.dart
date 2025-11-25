import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workin/screens/workout_screen.dart';
import 'package:workin/widgets/add_workout_button.dart';
import 'package:workin/widgets/home_app_bar.dart';
import 'package:workin/widgets/workoutcard.dart';

import '../appconstants.dart';
import '../data/notifiers.dart';
import '../models/workout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = Hive.box<Workout>('workouts');

    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        floatingActionButton: AddWorkoutButton(),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: ValueListenableBuilder<Box<Workout>>(
                  valueListenable: workouts.listenable(),
                  builder: (context, box, _) {
                    final workouts = box.values.toList();
                    return ListView(
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
                        for (var workout in workouts)
                          WorkoutcardWidget(workout: workout),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
