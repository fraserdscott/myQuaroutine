import 'package:flutter/cupertino.dart';

class Category {
  final String name;
  final String info;
  final Widget allowedInfo;
  final int limit;
  final List<String> goalSuggestions;

  // Goals initially have no ID as this is auto incremented from database
  // Goals are initially not completed
  Category({this.name, this.info, this.allowedInfo=const Text(""), this.limit=1000, this.goalSuggestions});
}
