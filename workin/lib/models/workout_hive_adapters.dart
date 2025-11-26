import 'package:hive/hive.dart';
import 'workout_result.dart';

class ExerciseSetAdapter extends TypeAdapter<ExerciseSet> {
  @override
  final int typeId = 2; // must be unique app-wide

  @override
  ExerciseSet read(BinaryReader reader) {
    final reps = reader.readDouble();
    final weight = reader.readDouble();
    final exercise = reader.readString();
    final rpe = reader.readDouble();
    return ExerciseSet(
      reps: reps,
      weight: weight,
      exercise: exercise,
      rpe: rpe,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSet obj) {
    writer
      ..writeDouble(obj.reps)
      ..writeDouble(obj.weight)
      ..writeString(obj.exercise)
      ..writeDouble(obj.rpe);
  }
}

class RestAdapter extends TypeAdapter<Rest> {
  @override
  final int typeId = 3;

  @override
  Rest read(BinaryReader reader) {
    final seconds = reader.readInt();
    return Rest(duration: Duration(seconds: seconds));
  }

  @override
  void write(BinaryWriter writer, Rest obj) {
    writer.writeInt(obj.duration.inSeconds);
  }
}

class WorkoutBlockAdapter extends TypeAdapter<WorkoutBlock> {
  @override
  final int typeId = 4;

  @override
  WorkoutBlock read(BinaryReader reader) {
    final list = reader.readList().cast<WorkoutObject>();
    return WorkoutBlock(setsAndReps: list);
  }

  @override
  void write(BinaryWriter writer, WorkoutBlock obj) {
    writer.writeList(obj.setsAndReps);
  }
}
