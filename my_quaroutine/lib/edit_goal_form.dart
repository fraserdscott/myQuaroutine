import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Goal.dart';

import 'database_helpers.dart';

class EditGoalForm extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  EditGoalFormState createState() {
    return EditGoalFormState();
  }
}

class EditGoalFormState extends State<EditGoalForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    final Goal goal = ModalRoute.of(context).settings.arguments;

    final _controller = TextEditingController(text: goal.name);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              goal.name = _name;
              updateGoal(goal);
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        ),
        appBar: AppBar(
          title: Text("Rename goal"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    controller: _controller,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.directions_run),
                      labelText: 'New goal name',
                      hintText: 'eg. Cooking',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  )),
            ],
          ),
        ));
  }
}
