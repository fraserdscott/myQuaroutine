import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Goal.dart';
import "dart:math";

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

  final _random = new Random();

  // todo refactor category strings into a class?
  Map<String, List<String>> suggestions = {"Personal goals": ["Have a dance party", "Learn how to do the worm", "Learn slang in another language"]};

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    final _controller = TextEditingController();

    void initState() {
      _controller.addListener(() {
        final text = _controller.text.toLowerCase();
        _controller.value = _controller.value.copyWith(
          text: text,
          selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });
      super.initState();
    }

    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        floatingActionButton: FloatingActionButton(
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
              TextFormField(
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
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text("Give me a suggestion!"),
                    onPressed: () {
                      _controller.text = suggestions[args.type][_random.nextInt(suggestions[args.type].length)];
                    },
                  )),
            ],
          ),
        ));
  }
}
