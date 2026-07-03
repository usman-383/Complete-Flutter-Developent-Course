import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

  print(
    "Hello, World!",
  ); // Print statement to display a message in the console.
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "Hello, World!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
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
