import 'package:flutter/material.dart';
import 'package:my_quaroutine/database_helpers.dart';
import 'package:my_quaroutine/models/Category.dart';
import 'package:my_quaroutine/models/Goal.dart';

import '../create_goal_form.dart';

class ViewActivityButton extends StatefulWidget {
  final Goal goal;
  ViewActivityButton({this.goal});

  @override
  ViewActivityButtonState createState() => new ViewActivityButtonState();
}

class ViewActivityButtonState extends State<ViewActivityButton> {
  bool _activityComplete;

  @override
  Widget build(BuildContext context) {
    _activityComplete = widget.goal.complete;
    return SizedBox(
        width: 150,
        child: FlatButton(
            child: Stack(children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    widget.goal.name,
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  )),
              Container(
                  alignment: Alignment.center,
                  child: tick_or_not(_activityComplete)),
            ]),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
                side: BorderSide(color: Colors.red)),
            onPressed: () {
              widget.goal.complete = !widget.goal.complete;
              updateGoal(widget.goal);
              setState(() {
                _activityComplete = widget.goal.complete;
              });
            }));
  }
}

Widget tick_or_not(activityCompleted) {
  if (activityCompleted) {
    return Icon(
      Icons.check,
      color: Colors.green,
      size: 140,
    );
  }
}

class CreateActivityButton extends StatelessWidget {
  final Category category;
  CreateActivityButton({this.category});

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
              Navigator.pushNamed(context, CreateGoalForm.routeName,
                  arguments: category);
            }));
  }
}
