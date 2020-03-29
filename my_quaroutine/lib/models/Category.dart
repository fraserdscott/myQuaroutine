class Category {
  final String name;
  final String info;
  final List<String> goalSuggestions;

  // Goals initially have no ID as this is auto incremented from database
  // Goals are initially not completed
  Category({this.name, this.info, this.goalSuggestions});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'info': info,
      'goalSuggestions': goalSuggestions,
    };
  }
}
