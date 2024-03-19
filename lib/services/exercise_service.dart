import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/models/exercise.dart';

class ExercisesService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExercise(String name, muscleGroup, intensityTechnique) {
    final String currentUserID = _auth.currentUser!.uid;

    Exercise newExercise = Exercise(
      name: name,
      muscleGroup: muscleGroup,
      intensityTechnique: intensityTechnique,
    );

    return _firestore
        .collection("Users")
        .doc(currentUserID)
        .collection("exercises")
        .add(newExercise.toMap());
  }

  Stream<QuerySnapshot> getExercises() {
    return _firestore
        .collection('Exercises')
        .orderBy('name')
        .snapshots();
  }
}
