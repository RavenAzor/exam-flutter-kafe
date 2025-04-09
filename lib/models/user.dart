class User {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final int deeVee;
  final int goldenGrains;

  User({
    this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.deeVee = 10,
    this.goldenGrains = 0,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      deeVee: data['deeVee'] ?? 10,
      goldenGrains: data['goldenGrains'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'deeVee': deeVee,
      'goldenGrains': goldenGrains,
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    int? deeVee,
    int? goldenGrains,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      deeVee: deeVee ?? this.deeVee,
      goldenGrains: goldenGrains ?? this.goldenGrains,
    );
  }
}
