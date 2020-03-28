class Activity {
  final String name;
  final String type;

  Activity({this.name, this.type});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type
    };
  }
}