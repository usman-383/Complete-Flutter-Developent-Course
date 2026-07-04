import 'package:flutter/material.dart';
import 'package:flutter_programming_fundamentals/Pages/second_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("1st Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //navigate to second page.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child: Text("Go To Second Page"),
        ),
      ),
    );
  }
}
