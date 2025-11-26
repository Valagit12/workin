import 'package:flutter/material.dart';
import 'package:workin/data/notifiers.dart';
import 'package:workin/models/workout_hive_adapters.dart';
import 'package:workin/widgets/workinapp_widget.dart';
import 'package:workin/widgets/workoutcard.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/workout.dart';
import 'models/workout_result.dart';
import 'screens/workout_screen.dart';
import 'appconstants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutResultAdapter());
  Hive.registerAdapter(WorkoutBlockAdapter());
  Hive.registerAdapter(ExerciseSetAdapter());
  Hive.registerAdapter(RestAdapter());

  await Hive.openBox<Workout>('workouts');
  await Hive.openBox<WorkoutResult>('workout_results');

  runApp(const WorkinApp());
}
