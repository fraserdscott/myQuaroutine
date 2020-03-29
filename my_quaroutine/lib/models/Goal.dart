class Goal {
  final int id;
  String name;
  final String type;
  final DateTime date;
  bool complete;

  Goal({this.id = -1, this.name, this.type, this.date, this.complete = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'date': date.toString().substring(0,10),
      'complete': complete,
    };
  }
}
