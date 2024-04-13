import 'package:workout_app/models/exercise.dart';

class ExerciseData {
  Exercise exercise;
  int setNumber;
  int reps;
  double weight;

  ExerciseData({
    required this.exercise,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  /// Maps the member variables of Exercise to strings that will make it easier
  /// to read in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': exercise.name,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
    };
  }
}
