import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_quaroutine/models/Activity.dart';

void createDatabase() async {
  // run this whne you update columns etc
  //await deleteDatabase(join(await getDatabasesPath(), 'activity_database.db'));
  openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'activity_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, type TEXT, complete BIT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> updateActivity(Activity dog) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'activity_database.db'),
  );

  // Get a reference to the database.
  final db = await database;

  // Update the given Dog.
  await db.update(
    'dogs',
    dog.toMap(),
    // Ensure that the Dog has a matching id.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [dog.id],
  );
}

Future<void> deleteActivity(int id) async {
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
Future<void> insertActivity(Activity activity) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'activity_database.db'),
  );

  final Database db = await database;

  Map<String, dynamic> withoutID = activity.toMap();
  withoutID.remove("id");

  await db.insert(
    'dogs',
    withoutID,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


// A method that retrieves all the dogs from the dogs table.
Future<List<Activity>> activities() async {
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
    bool lol = true;
    if (maps[i]['complete'] == 0){
      lol = false;
    }
    return Activity(
      name: maps[i]['name'],
      type: maps[i]['type'],
      complete: lol,
    );
  });
}