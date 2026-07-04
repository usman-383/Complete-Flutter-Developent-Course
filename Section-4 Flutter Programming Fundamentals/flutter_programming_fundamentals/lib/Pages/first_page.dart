import 'package:flutter/material.dart';
// import 'package:flutter_programming_fundamentals/Pages/second_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("1st Page")),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //navigate to second page.

            Navigator.pushNamed(context, '/SecondPage');

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => SecondPage()),
            // );
          },
          child: Text("Go To Second Page"),
        ),
      ),
    );
  }
}
