import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Goal.dart';

import 'database_helpers.dart';
import 'components/buttons.dart';

class CreateGoalForm extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  CreateGoalFormState createState() {
    return CreateGoalFormState();
  }
}

class CreateGoalFormState extends State<CreateGoalForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text("Create a new goal"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.directions_run),
                  hintText: 'eg. Cooking',
                  labelText: 'Goal name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      final newGoal = Goal(
                        name: _name,
                        type: args.type,
                      );
                      insertGoal(newGoal);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Create goal'),
                ),
              ),
            ],
          ),
        ));
  }
}
