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

  Map<String, dynamic> toMap() {
    return {
      'name': exercise.name,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
    };
  }
}
