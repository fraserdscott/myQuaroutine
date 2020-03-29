class Goal {
  final int id;
  final String name;
  final String type;
  bool complete;

  // Goals initially have no ID as this is auto incremented from database
  // Goals are initially not completed
  Goal({this.id = -1, this.name, this.type, this.complete = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'complete': complete,
    };
  }
}
