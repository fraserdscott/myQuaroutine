import 'package:flutter/material.dart';
import 'package:my_quaroutine/models/Activity.dart';

import 'database_helpers.dart';
import 'components/buttons.dart';


class MyCustomForm extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    print(args.type);

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text("good evening"),
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
                  labelText: 'Activity name',
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
                      final activity = Activity(
                        id: -1,
                        name: _name,
                        type: args.type,
                        complete: false,
                      );
                      insertActivity(activity);
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Create goal'),
                ),
              ),
            ],
          ),
        ));
  }
}
