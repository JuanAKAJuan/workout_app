import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:rxdart/rxdart.dart';

class ExercisesService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExercise(String name, muscleGroup, intensityTechnique) async {
    final String currentUserID = _auth.currentUser!.uid;

    Exercise newExercise = Exercise(
      name: name,
      muscleGroup: muscleGroup,
      intensityTechnique: intensityTechnique,
    );

    await _firestore
        .collection("Users")
        .doc(currentUserID)
        .collection("exercises")
        .add(newExercise.toMap());
  }

  Stream<QuerySnapshot> getExercises() {
    return _firestore.collection("Exercises").orderBy("name").snapshots();
  }

  Stream<List<Map<String, dynamic>>> getCombinedExercises() {
    final String currentUserID = _auth.currentUser!.uid;
    Stream<List<DocumentSnapshot>> defaultExercises = _firestore
        .collection("Exercises")
        .snapshots()
        .map((snapshot) => snapshot.docs);
    Stream<List<DocumentSnapshot>> userExercises = _firestore
        .collection("Users")
        .doc(currentUserID)
        .collection("exercises")
        .snapshots()
        .map((snapshot) => snapshot.docs);

    return Rx.combineLatest2(defaultExercises, userExercises,
        (List<DocumentSnapshot> docs1, List<DocumentSnapshot> docs2) {
      List<Map<String, dynamic>> combinedExercises = [];
      combinedExercises
          .addAll(docs1.map((doc) => doc.data() as Map<String, dynamic>));
      combinedExercises
          .addAll(docs2.map((doc) => doc.data() as Map<String, dynamic>));

      // Sort the combined list of exercises and put them into alphabetical order.
      combinedExercises
          .sort((a, b) => (a["name"] as String).compareTo(b["name"] as String));

      return combinedExercises;
    });
  }
}
