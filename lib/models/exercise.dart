class Exercise {
  final String name;
  final String muscleGroup;
  final String intensityTechnique;

  Exercise({
    required this.name,
    required this.muscleGroup,
    required this.intensityTechnique,
  });

  /// Maps the member variables of Exercise to strings that will make it easier
  /// to read in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'muscleGroup': muscleGroup,
      'intensityTechnique': intensityTechnique,
    };
  }
}
