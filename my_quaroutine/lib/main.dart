import 'package:flutter/material.dart';
import 'package:my_quaroutine/theme/style.dart';
import 'lol.dart';
import 'database_helpers.dart';

import 'package:my_quaroutine/models/Activity.dart';

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
        body: projectWidget());
  }
}


Widget projectWidget() {
  List<String> cats = ["Personal", "Indoor fitness goal", "Shopping trips"];

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
                      child: listView(cats[index], snapshot.data))
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
      onPressed: () {});
}

Widget newActivity(context, type) {
  return FlatButton(
      child: Icon(Icons.add),
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(0.0),
          side: BorderSide(color: Colors.red)),
      onPressed: () {
        Navigator.pushNamed(
          context,
          MyCustomForm.routeName,
          arguments: ScreenArguments(
            type,
          ),
        );
      });
}

// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.
class ScreenArguments {
  final String type;

  ScreenArguments(this.type, );
}


Widget listView(type, data){
  List<Activity> meme = data.where((i) => i.type == type).toList();
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: meme.length + 1,
      itemBuilder: (context, index) {
        if (index == meme.length) {
          return newActivity(context, type);
        }
        return activityButton(
            context, meme[index].name);
      });
}
