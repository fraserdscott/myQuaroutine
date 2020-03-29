import 'package:flutter/material.dart';

class CreateShoppingListForm extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  CreateShoppingListFormState createState() {
    return CreateShoppingListFormState();
  }
}

class CreateShoppingListFormState extends State<CreateShoppingListForm> {
  List<String> batman = ["food"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        ),
        appBar: AppBar(
          title: Text("Create a shopping list"),
        ),
        body: ListView.builder(
            itemCount: batman.length+1,
            itemBuilder: (context, index) {
              String initValue = "";
              if (index < batman.length) {
                initValue = batman[index];
              }

              return TextFormField(
                  decoration: const InputDecoration(
                  icon: Icon(Icons.check_circle_outline),
                  hintText: 'eg. Tomatoes',
                ),
                initialValue: initValue,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onEditingComplete: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }},
              );
            }));
  }
}
