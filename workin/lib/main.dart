import 'package:flutter/material.dart';
import 'package:workin/data/notifiers.dart';
import 'package:workin/widgets/workinapp_widget.dart';
import 'package:workin/widgets/workoutcard.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/workout.dart';
import 'screens/workout_screen.dart';
import 'appconstants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(WorkoutAdapter());
  // Hive.registerAdapter(ExerciseAdapter());
  // Hive.registerAdapter(ExerciseSetAdapter());

  await Hive.openBox<Workout>('workouts');

  runApp(
    const WorkinApp(),
  ); // why does nothing change when I swap WorkinApp for HomeScreen
}
