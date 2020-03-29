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
      goalSuggestions: [
        "Have a dance party",
        "Learn how to do the worm",
        "Learn slang in another language"
      ]),
  Category(
      name: "Shopping",
      info:
          "The UK government allows shopping for basic necessities: “as infrequently as possible”",
      goalSuggestions: [
        "Have a dance party",
        "Learn how to do the worm",
        "Learn slang in another language"
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
    //for (int i = 0; i < 29; i++) deleteActivity(i);

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
                      false
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
                            _ackAlert(context, cats[index]);
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
                      child: ListThing(
                          pee: Poo(cat: cats[index], data: snapshot.data)))
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

class Poo {
  Category cat;
  List<Goal> data;

  Poo({this.cat, this.data});
}

class ListThing extends StatelessWidget {
  final Poo pee;
  ListThing({this.pee});

  @override
  Widget build(BuildContext context) {
    List<Goal> meme = pee.data.where((i) => i.type == pee.cat.name).toList();
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: meme.length + 1,
        itemBuilder: (context, index) {
          if (index == meme.length) {
            return CreateActivityButton(
              cat: pee.cat,
            );
          }
          return ViewActivityButton(
            activity: meme[index],
          );
        });
  }
}

Future<void> _ackAlert(BuildContext context, Category cat) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(cat.name),
        content: Text(cat.info),
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
