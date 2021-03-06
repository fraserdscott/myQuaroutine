import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Goal.dart';
import "dart:math";
import 'components/buttons.dart';

import 'database_helpers.dart';

class CreateGoalForm extends StatefulWidget {
  static const routeName = '/extractArguments2';

  @override
  CreateGoalFormState createState() {
    return CreateGoalFormState();
  }
}

class CreateGoalFormState extends State<CreateGoalForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;

  final _random = new Random();

  @override
  Widget build(BuildContext context) {
    final Data args = ModalRoute.of(context).settings.arguments;

    final _controller = TextEditingController();

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              final newGoal = Goal(
                name: _name,
                type: args.category.name,
                date: args.date,
              );

              insertGoal(newGoal);
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        ),
        appBar: AppBar(
          title: Text("Create a new goal"),
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
                      labelText: 'Goal name',
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
              Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text("Give me a suggestion!"),
                    onPressed: () {
                      _controller.text = args.category.goalSuggestions[_random
                          .nextInt(args.category.goalSuggestions.length)];
                    },
                  )),
              args.category.allowedInfo,
            ],
          ),
        ));
  }
}
