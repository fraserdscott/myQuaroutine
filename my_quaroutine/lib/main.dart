import 'package:flutter/material.dart';
import 'package:my_quaroutine/theme/style.dart';
import 'lol.dart';
import 'database_helpers.dart';
import 'components/buttons.dart';
import 'package:intl/intl.dart';

import 'package:my_quaroutine/models/Activity.dart';

List<String> cats = ["Personal goals", "Indoor fitness goal", "Shopping trips"];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MyCustomForm.routeName: (context) => MyCustomForm(),
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
    for (int i = 0; i < 29; i++) {
      //deleteDog(i);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
                color: Colors.grey,
                padding: EdgeInsets.only(left: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      DateFormat('EEE d MMM').format(DateTime.now()),
                      style: TextStyle(fontSize: 35),
                    ))),
            projectWidget()
          ],
        ));
  }
}

Widget projectWidget() {
  return new Expanded(
      child: FutureBuilder<List<Activity>>(
    future: activities(),
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
                          '${cats[index]}',
                          style: TextStyle(fontSize: 30.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            _ackAlert(context, cats[index]);
                          },
                        )
                      ])),
                  Container(
                      height: 150.0,
                      child: ListThing(
                          pee: Poo(type: cats[index], data: snapshot.data)))
                ]);
              },
            );
      }
    },
  ));
}

class Poo {
  String type;
  List<Activity> data;

  Poo({this.type, this.data});
}

class ListThing extends StatelessWidget {
  final Poo pee;
  ListThing({this.pee});

  @override
  Widget build(BuildContext context) {
    List<Activity> meme = pee.data.where((i) => i.type == pee.type).toList();
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: meme.length + 1,
        itemBuilder: (context, index) {
          if (index == meme.length) {
            return CreateActivityButton(
              data: new Data(text: pee.type),
            );
          }
          return ViewActivityButton(
            data: meme[index],
          );
        });
  }
}

Future<void> _ackAlert(BuildContext context, String type) {
  Map<String, String> me = Map.fromIterable(cats);
  me["Personal goals"] = "Stuff you'd do around the house";
  me["Indoor fitness goal"] =
      "The UK government allows one form of outdoor exercise a day, for example, a run, walk, or cycle: alone or with members of your household";
  me["Shopping trips"] =
      "The UK government allows shopping for basic necessities: “as infrequently as possible”";
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(type),
        content: Text(me[type]),
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
