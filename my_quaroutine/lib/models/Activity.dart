class Activity {
  final int id;
  final String name;
  final String type;
  bool complete;

  Activity({this.id, this.name, this.type, this.complete});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'type': type,
      'complete': complete,
    };
  }
}