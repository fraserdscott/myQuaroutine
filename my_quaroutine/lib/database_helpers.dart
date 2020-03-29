import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_quaroutine/models/Goal.dart';

void createDatabase() async {
  // run this when you update columns etc
  //await deleteDatabase(join(await getDatabasesPath(), 'activity_database.db'));
  openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'activity_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, type TEXT, date DATE, complete BIT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> updateGoal(Goal goal) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'activity_database.db'),
  );

  // Get a reference to the database.
  final db = await database;

  await db.update(
    'dogs',
    goal.toMap(),
    // Ensure that the Dog has a matching id.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [goal.id],
  );
}

Future<void> deleteGoal(int id) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'activity_database.db'),
  );

  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'dogs',
    // Use a `where` clause to delete a specific dog.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}


// Define a function that inserts dogs into the database
Future<void> insertGoal(Goal goal) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'activity_database.db'),
  );

  final Database db = await database;

  Map<String, dynamic> withoutID = goal.toMap();
  withoutID.remove("id");

  await db.insert(
    'dogs',
    withoutID,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


// A method that retrieves all the dogs from the dogs table.
Future<List<Goal>> goals() async {
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'activity_database.db'),
  );

  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('dogs');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    bool goalComplete = true;
    if (maps[i]['complete'] == 0){
      goalComplete = false;
    }
    return Goal(
      id: maps[i]['id'],
      name: maps[i]['name'],
      type: maps[i]['type'],
      date: DateTime.parse(maps[i]['date']),
      complete: goalComplete,
    );
  });
}