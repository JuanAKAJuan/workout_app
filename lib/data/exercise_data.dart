import 'package:workout_app/models/exercise.dart';

class ExerciseData {
  Exercise exercise;
  String sets;
  String reps;
  String weight;
  bool isCompleted;

  ExerciseData({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weight,
    this.isCompleted = false,
  });

  /// Maps the member variables of Exercise to strings that will make it easier
  /// to read in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': exercise.name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'isCompleted': isCompleted,
    };
  }
}
