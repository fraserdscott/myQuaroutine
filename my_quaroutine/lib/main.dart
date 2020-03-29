import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Category.dart';
import 'package:my_quaroutine/theme/style.dart';
import 'create_goal_form.dart';
import 'database_helpers.dart';
import 'components/buttons.dart';
import 'package:intl/intl.dart';

import 'package:my_quaroutine/models/Goal.dart';

List<Category> cats = [
  Category(
      name: "Personal goals",
      info: "Stuff you'd do around the house",
      goalSuggestions: [
        "Have a dance party",
        "Learn how to do the worm",
        "Learn slang in another language"
      ]),
  Category(
      name: "Outdoor fitness goal",
      info:
          "The UK government allows one form of outdoor exercise a day, for example, a run, walk, or cycle: alone or with members of your household",
      limit: 1,
      goalSuggestions: [
        "Go for 30 minute run",
        "Walk the door",
        "Walk with family member"
      ]),
  Category(
      name: "Shopping",
      info:
          "The UK government allows shopping for basic necessities: “as infrequently as possible”",
      goalSuggestions: [
        "Don't overbuy toilet paper",
      ]),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CreateGoalForm.routeName: (context) => CreateGoalForm(),
      },
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
  @override
  Widget build(BuildContext context) {
    createDatabase();
    //for (int i = 0; i < 29; i++) deleteGoal(i);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
                color: Colors.grey,
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      true
                          ? DateFormat('EEE d MMM').format(DateTime.now())
                          : "Today",
                      style: TextStyle(fontSize: 35),
                    ))),
            projectWidget()
          ],
        ));
  }
}

Widget projectWidget() {
  return new Expanded(
      child: FutureBuilder<List<Goal>>(
    future: goals(),
    builder: (BuildContext context, AsyncSnapshot<List<Goal>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading....');
        default:
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          else
            return ListView.separated(
              itemCount: cats.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 20,
                color: Colors.white,
              ),
              itemBuilder: (context, index) {
                return Column(children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: <Widget>[
                        Text(
                          '${cats[index].name}',
                          style: TextStyle(fontSize: 30.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            _categoryInfoAlert(context, cats[index]);
                          },
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                              padding: EdgeInsets.only(right: 10),
                              alignment: Alignment.bottomRight,
                              child: Text(
                                makeCompletedCount(cats[index], snapshot.data),
                                style: TextStyle(fontSize: 20),
                              )),
                        )
                      ])),
                  Container(
                      height: 150.0,
                      child: GoalListView(
                          container: GoalAndFilterContainer(filterCategory: cats[index], goals: snapshot.data)))
                ]);
              },
            );
      }
    },
  ));
}

String makeCompletedCount(Category cat, data) {
  // Fixme to work when updated on screen
  return data
          .where((i) => i.type == cat.name && i.complete == true)
          .toList()
          .length
          .toString() +
      "/" +
      data.where((i) => i.type == cat.name).toList().length.toString();
}

class GoalAndFilterContainer {
  Category filterCategory;
  List<Goal> goals;

  GoalAndFilterContainer({this.filterCategory, this.goals});
}

class GoalListView extends StatelessWidget {
  final GoalAndFilterContainer container;
  GoalListView({this.container});

  @override
  Widget build(BuildContext context) {
    List<Goal> filteredGoals = container.goals.where((i) => i.type == container.filterCategory.name).toList();
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: min(filteredGoals.length + 1, container.filterCategory.limit),
        itemBuilder: (context, index) {
          if (index == filteredGoals.length && !(index >= container.filterCategory.limit)) {
            return CreateActivityButton(
              category: container.filterCategory,
            );
          }
          return ViewActivityButton(
            goal: filteredGoals[index],
          );
        });
  }
}

Future<void> _categoryInfoAlert(BuildContext context, Category category) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(category.name),
        content: Text(category.info),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
