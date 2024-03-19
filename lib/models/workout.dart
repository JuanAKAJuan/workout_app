import 'package:workout_app/models/exercise_data.dart';

class Workout {
  String name;
  List<ExerciseData> exerciseSets;

  Workout({
    required this.exerciseSets,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exerciseSets': exerciseSets,
    };
  }
}
