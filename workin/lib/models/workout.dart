import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(3)
  List<Exercise> exercises;

  Workout({required this.id, required this.name, required this.exercises});
}

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<ExerciseSet> sets;

  Exercise({required this.name, required this.sets});
}

@HiveType(typeId: 2)
class ExerciseSet {
  @HiveField(0)
  int reps;

  @HiveField(1)
  double weight;

  @HiveField(2)
  double resttime;

  ExerciseSet({
    required this.reps,
    required this.weight,
    required this.resttime,
  });
}
