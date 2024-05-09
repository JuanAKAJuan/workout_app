import 'package:workout_app/data/exercise_data.dart';

class Workout {
  String name;
  List<ExerciseData> exercises;

  Workout({
    required this.name,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exercises': exercises,
    };
  }
}
