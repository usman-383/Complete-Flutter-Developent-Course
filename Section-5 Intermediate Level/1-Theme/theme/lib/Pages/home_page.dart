import 'package:flutter/material.dart';
import 'package:theme/Components/button.dart';
import '../Components/box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple[500],
      appBar: AppBar(title: const Text('Theme Demo')),
      body: Center(child: MyBox(
        color: Colors.deepPurple[300],
        child: MyButton(color:Colors.deepPurple[200],onTap: (){();},
      ),),
    );
  }
}
