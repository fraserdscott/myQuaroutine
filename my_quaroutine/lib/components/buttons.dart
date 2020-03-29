import 'package:flutter/material.dart';
import 'package:my_quaroutine/database_helpers.dart';
import 'package:my_quaroutine/models/Activity.dart';

import '../lol.dart';

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
  final Activity data;
  ViewActivityButton({this.data});

  @override
  ViewActivityButtonState createState() => new ViewActivityButtonState();
}

class ViewActivityButtonState extends State<ViewActivityButton> {
  bool _activity_complete = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: FlatButton(
            child: Column(children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    widget.data.name,
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.bottomCenter,
                      child: ricky(_activity_complete))),
            ]),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
                side: BorderSide(color: Colors.red)),
              onPressed: (){
              widget.data.complete = !widget.data.complete;
              updateActivity(widget.data);
              setState((){
                _activity_complete = widget.data.complete;
              });
            }));
  }
}

Widget ricky(metal){
  if (metal) {
    return Icon(
      Icons.verified_user,
      size: 50,
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
            child: Icon(Icons.add),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0),
                side: BorderSide(color: Colors.red)),
            onPressed: () {
              Navigator.pushNamed(
                context,
                MyCustomForm.routeName,
                arguments: ScreenArguments(
                  data.text,
                ),
              );
            }));
  }
}
