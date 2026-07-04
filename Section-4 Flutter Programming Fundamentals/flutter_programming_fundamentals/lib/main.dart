import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

  // print(
  //   "Hello, World!",
  // ); // Print statement to display a message in the console.
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // List name = ["Usman", "Khan", "Daniyal", "Zohaib", "Anyone"];

  //Function and methods.
  void userTapped() {
    print("User tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple[200],

        appBar: AppBar(
          title: Center(child: Text("Flutter Basics")),
          backgroundColor: Colors.deepPurple,
          elevation: 4,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              print('menu pressed');
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('search pressed');
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                print('notifications pressed');
              },
            ),
          ],
        ),

        body: GestureDetector(
          onTap: userTapped,
          child: Container(
            height: 200,
            width: 200,
            color: Colors.deepPurple[200],
            child: Center(child: Text("Tap me")),
          ),
        ),

        // Stack(
        //   alignment: Alignment.bottomCenter,
        //   children: [
        //     //Big box
        //     Container(height: 300, width: 300, color: Colors.blueAccent),

        //     //Middle box
        //     Container(height: 200, width: 200, color: Colors.deepPurple),

        //     //Small box
        //     Container(height: 100, width: 100, color: Colors.green),
        //   ],
        // ),

        //  GridView.builder(
        //   itemCount: 64,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 4,
        //   ),
        //   itemBuilder: (context, index) =>
        //       Container(color: Colors.deepOrange, margin: EdgeInsets.all(2)),
        // ),

        //  ListView.builder(
        //   itemCount: name.length,
        //   itemBuilder: (context, index) => ListTile(title: Text(name[index])),
        // ),

        // Column

        // ListView(
        //   // scrollDirection: Axis.horizontal,
        //   // mainAxisAlignment: MainAxisAlignment.center,

        //   // crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     //1st box
        //     Expanded(
        //       child: Container(
        //         height: 200,
        //         //  width: 150,
        //         color: Colors.deepPurple,
        //       ),
        //     ),

        //     //2nd box
        //     Expanded(
        //       flex: 2,
        //       child: Container(
        //           height: 200,
        //         //  width: 150,
        //         color: Colors.deepPurple[400],
        //       ),
        //     ),

        //     //3rd box
        //     Expanded(
        //       child: Container(
        //         height: 200,
        //         // width: 150,
        //         color: Colors.deepPurple[600],
        //       ),
        //     ),
        //   ],
        // ),

        // Center(
        //   child: Container(
        //     height: 300,
        //     width: 300,
        //     decoration: BoxDecoration(
        //       color: Colors.blueAccent,
        //       borderRadius: BorderRadius.circular(20),
        //     ),

        //Text portion
        //     child: Center(
        //       child:
        //           // You can uncomment the following code to display text instead of an icon.
        //           // Text(
        //           //   "Hello, World!",
        //           //   style: TextStyle(
        //           //     fontSize: 24,
        //           //     fontWeight: FontWeight.bold,
        //           //     color: Colors.white,
        //           //   ),
        //           // ),
        //           //Icon widget to display a Flutter icon in the center of the container.
        //Icon portion
        //           Icon(Icons.flutter_dash, size: 100, color: Colors.white),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

  //Variables: Used for storing different data types and values in the application.
  // String name = "Usman dev";
  // int age = 20;
  // double height = 5.9;
  // bool isStudent = true;

/*Basic Math operations: Performing simple arithmetic calculations using variables.
  int sum = 10 + 5; // Addition
  int difference = 10 - 5; // Subtraction
  int product = 10 * 5; // Multiplication
  double quotient = 10 / 5; // Division
  int remainder = 10 % 3; // Modulus
*/

/*Comparison Operators: Comparing values and returning boolean results.
int a = 10;
int b = 5;
bool isEqual = a == b; // Equal to
bool isNotEqual = a != b; // Not equal to
bool isGreater = a > b; // Greater than
bool isLess = a < b; // Less than
bool isGreaterOrEqual = a >= b; // Greater than or equal to
bool isLessOrEqual = a <= b; // Less than or equal to
*/

/*
Logical operator: Combining multiple conditions and returning boolean results.
bool isTrue = true;
bool isFalse = false;
bool andResult = isTrue && isFalse; // Logical AND
bool orResult = isTrue || isFalse; // Logical OR
bool notResult = !isTrue; // Logical NOT
*/
