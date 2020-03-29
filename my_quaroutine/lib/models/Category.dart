class Category {
  final String name;
  final String info;
  final int limit;
  final List<String> goalSuggestions;

  // Goals initially have no ID as this is auto incremented from database
  // Goals are initially not completed
  Category({this.name, this.info, this.limit=1000, this.goalSuggestions});
}
