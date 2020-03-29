import 'package:flutter/material.dart';
import 'package:my_quaroutine/database_helpers.dart';
import 'package:my_quaroutine/models/Goal.dart';

import '../create_goal_form.dart';

class Data {
  String text;
  Data({this.text});
}

class ScreenArguments {
  final String type;

  ScreenArguments(
    this.type,
  );
}
class ViewActivityButton extends StatefulWidget {
  final Goal activity;
  ViewActivityButton({this.activity});

  @override
  ViewActivityButtonState createState() => new ViewActivityButtonState();
}

class ViewActivityButtonState extends State<ViewActivityButton> {
  bool _activityComplete;

  @override
  Widget build(BuildContext context) {
    _activityComplete = widget.activity.complete;
    return SizedBox(
        width: 150,
        child: FlatButton(
            child: Stack(children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    widget.activity.name,
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  )),
                  Container(
                      padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: tick_or_not(_activityComplete)),
            ]),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
                side: BorderSide(color: Colors.red)),
              onPressed: (){
              widget.activity.complete = !widget.activity.complete;
              updateGoal(widget.activity);
              setState((){
                _activityComplete = widget.activity.complete;
              });
            }));
  }
}

Widget tick_or_not(activityCompleted){
  if (activityCompleted) {
    return Icon(
      Icons.thumb_up,
      color: Colors.green,
      size: 100,
    );
  }
}

class CreateActivityButton extends StatelessWidget {
  final Data data;
  CreateActivityButton({this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: FlatButton(
            child: Icon(Icons.add, size: 50),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
                side: BorderSide(color: Colors.red)),
            onPressed: () {
              Navigator.pushNamed(
                context,
                CreateGoalForm.routeName,
                arguments: ScreenArguments(
                  data.text,
                ),
              );
            }));
  }
}
