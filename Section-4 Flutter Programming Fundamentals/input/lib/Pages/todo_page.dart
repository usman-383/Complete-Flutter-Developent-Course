import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  //Text editing controller to get access what user typed
  TextEditingController myController = TextEditingController();

  //greet user method
  void greetUser() {
    print(myController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TextField
            TextField(
              controller: myController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),

            //Button
            ElevatedButton(onPressed: greetUser, child: Text("Tap")),
          ],
        ),
      ),
    );
  }
}
