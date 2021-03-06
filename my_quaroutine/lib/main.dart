import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Category.dart';
import 'package:my_quaroutine/theme/style.dart';
import 'create_goal_form.dart';
import 'database_helpers.dart';
import 'components/buttons.dart';
import 'package:intl/intl.dart';
import 'edit_goal_form.dart';

import 'package:my_quaroutine/models/Goal.dart';

List<Category> cats = [
  Category(
      name: "Personal goals",
      info: "Stuff you'd do around the house",
      goalSuggestions: [
        "Have a dance party",
        "Learn how to do the worm",
        "Learn slang in another language",
        "Solve the Rubik's cube",
        "Bake a cake",
        "Do spring cleaning",
        "Clean out cupboards",
        "Phone a friend",
        "Video call a family member",
      ]),
  Category(
      name: "Outdoor goal",
      info:
          "The UK government allows one form of outdoor exercise a day, for example, a run, walk, or cycle: alone or with members of your household",
      allowedInfo: Container(
          padding: EdgeInsets.all(30),
          decoration: ShapeDecoration.fromBoxDecoration(BoxDecoration(
            border: Border.all(width: 5),
          )),
          child: Column(children: <Widget>[
            Text("STAY AT HOME", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Text(
              '''

You can only leave home for:
🛒Shopping for basic necessities
🚴One form of exercise a day
🤒Any medical need or to help a vulnerable person
💼Travel to and from work, when this can't be done from home''',
              style: TextStyle(fontSize: 20),
            )
          ])),
      goalSuggestions: [
        "Go for 30 minute run",
        "Walk the dog",
        "Walk with family member",
        "Go out on bicycle"
      ]),
  Category(
      name: "Shopping",
      info:
          "The UK government allows shopping for basic necessities: “as infrequently as possible”",
      limit: 1,
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
        EditGoalForm.routeName: (context) => EditGoalForm(),
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
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 3),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

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
                color: Colors.black12,
                child: Row(children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            DateFormat('EEE  d MMM').format(selectedDate),
                            style: TextStyle(fontSize: 35),
                          ))),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.date_range),
                        color: Colors.redAccent,
                        onPressed: () => _selectDate(context),
                        iconSize: 40,
                      )),
                ])),
            projectWidget(selectedDate)
          ],
        ));
  }
}

Widget projectWidget(DateTime selectedDate) {
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
                  Row(children: <Widget>[
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
                            makeCompletedCount(
                                cats[index],
                                snapshot.data
                                    .where(
                                        (i) => isSameDate(i.date, selectedDate))
                                    .toList()),
                            style: TextStyle(fontSize: 20),
                          )),
                    )
                  ]),
                  Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    GoalGridView(
                        date: selectedDate,
                        filterCategory: cats[index],
                        goals: snapshot.data
                            .where((i) => isSameDate(i.date, selectedDate))
                            .toList())
                  ])
                ]);
              },
            );
      }
    },
  ));
}

bool isSameDate(date1, date2) {
  return date1.difference(date2).inDays == 0 && date1.day == date2.day;
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

//fixme this is broken when straight swapped with gridview
class GoalListView extends StatelessWidget {
  final Category filterCategory;
  final List<Goal> goals;
  final DateTime date;

  GoalListView({this.filterCategory, this.goals, this.date});

  @override
  Widget build(BuildContext context) {
    List<Goal> filteredGoals =
        goals.where((i) => i.type == filterCategory.name).toList();
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: min(filteredGoals.length + 1, filterCategory.limit),
        itemBuilder: (context, index) {
          if (index == filteredGoals.length &&
              !(index >= filterCategory.limit)) {
            return CreateActivityButton(
              category: filterCategory,
              date: date,
            );
          }
          return ViewActivityButton(
            goal: filteredGoals[index],
          );
        });
  }
}

class GoalGridView extends StatelessWidget {
  final Category filterCategory;
  final List<Goal> goals;
  final DateTime date;

  GoalGridView({this.filterCategory, this.goals, this.date});

  @override
  Widget build(BuildContext context) {
    List<Goal> filteredGoals =
        goals.where((i) => i.type == filterCategory.name).toList();

    List<Widget> tiles = [];
    for (int index = 0;
        index < min(filteredGoals.length + 1, filterCategory.limit);
        index++) {
      if (index == filteredGoals.length && !(index >= filterCategory.limit)) {
        tiles.add(CreateActivityButton(
          category: filterCategory,
          date: date,
        ));
      } else {
        tiles.add(ViewActivityButton(
          goal: filteredGoals[index],
        ));
      }
    }
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      children: tiles,
    );
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
