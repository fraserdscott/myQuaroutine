import 'package:flutter/material.dart';
import 'package:my_quaroutine/theme/style.dart';
import 'lol.dart';

import 'package:my_quaroutine/models/Activity.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My QuaRoutine',
      theme: appTheme(),
      home: MyHomePage(title: 'My QuaRoutine'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = ["Outdoor fitness goal", "Personal goals", "Shopping trip"];

  @override
  Widget build(BuildContext context) {
    create_database();
    for (int i = 0; i < 29; i++) {
      //deleteDog(i);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: projectWidget());
  }
}

void create_database() async {
  //await deleteDatabase(join(await getDatabasesPath(), 'activity_database.db'));

  final Future<Database> database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'activity_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, type TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> deleteDog(int id) async {
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

Widget projectWidget() {
  List<String> cats = ["Personal goals", "Indoor fitness goal", "Shopping trips"];
  return new FutureBuilder<List<Activity>>(
    future: dogs(), // async work
    builder: (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading....');
        default:
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          else
            return ListView.separated(
              itemCount: cats.length,

              separatorBuilder: (BuildContext context, int index) => Divider(height: 20, color: Colors.white,),
              itemBuilder: (context, index) {
                return Column(children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${cats[index]}',
                        style: TextStyle(fontSize: 30.0),
                      )),
                  Container(
                      height: 100.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (context, index) {
                            if (index == snapshot.data.length) {
                              return newActivity(context);
                            }
                            return activityButton(
                                context, snapshot.data[index].name);
                          }))
                ]);
              },
            );
      }
    },
  );
}

Widget activityButton(context, String text) {
  return FlatButton(
      child: Text(
        text,
        style: TextStyle(fontSize: 20.0),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.red)),
      onPressed: () {
        null;
      });
}

Widget newActivity(context) {
  return FlatButton(
      child: Icon(Icons.add),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.red)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCustomForm()),
        );
      });
}
