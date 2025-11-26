import 'package:hive/hive.dart';

part 'workout_result.g.dart';

abstract class WorkoutObject {
  const WorkoutObject();

  String get label;
}

class ExerciseSet extends WorkoutObject {
  final double reps;
  final double weight;
  final String exercise;
  final double rpe;

  ExerciseSet({
    required this.reps,
    required this.weight,
    required this.exercise,
    required this.rpe,
  });

  @override
  String get label => '$exercise: @$weight for $reps reps at RPE $rpe';
}

class Rest extends WorkoutObject {
  final Duration duration;

  Rest({required this.duration});

  int getMinutes() => duration.inMinutes;

  int getSeconds() => duration.inSeconds;

  @override
  String get label =>
      '${getMinutes() > 0 ? '${getMinutes()} minutes and ${getSeconds() - 60 * getMinutes()}' : '${getSeconds()}'} of rest';
}

class WorkoutBlock {
  final List<WorkoutObject> setsAndReps;

  WorkoutBlock({required this.setsAndReps});

  Duration get totalRest => setsAndReps.whereType<Rest>().fold(
    Duration.zero,
    (sum, r) => sum + r.duration,
  );

  int get totalSets => setsAndReps.whereType<ExerciseSet>().length;
}

@HiveType(typeId: 1)
class WorkoutResult extends HiveObject {
  @HiveField(0)
  String id; // same as workout id

  @HiveField(1)
  String name;

  @HiveField(2)
  List<WorkoutObject> workout;

  WorkoutResult({required this.id, required this.name, required this.workout});
}
