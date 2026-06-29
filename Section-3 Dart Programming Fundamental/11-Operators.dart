void main() {
  /*Operators:
          Operators are special symbols used for specific purpose
  
  Types of operators*/
  //1)Arithmetic operator: -> Include +, -, *, /, % etc
  //Example
  int num1 = 20;
  int num2 = 6;

  print("--------Arithmetic Operator-------");
  print("Addition: ${num1 + num2}"); // Output: 26
  print("Subtraction: ${num1 - num2}"); // Output: 14
  print("Multiplication: ${num1 * num2}"); // Output: 120
  print("Division: ${num1 / num2}"); // Output: 3.3333...
  print("Integer Division: ${num1 ~/ num2}"); // Output: 3
  print("Modulus: ${num1 % num2}"); // Output: 2

  //2)Assigning operator: -> include =, +=, -=, *=, /=.
  //Example
  int score = 0;

  score += 10; // score = 10
  score += 5; // score = 15
  score -= 3; // score = 12
  score *= 2; // score = 24

  print("---------Assignment Operator--------");
  print("Final score: $score"); // Output: Final score: 24

  //3)Relational operators: -> ==, >, <, >=, <=, != etc.
  //Example
  int age = 20;
  int minimumAge = 18;

  print("-----------Relational Operator--------");
  if (age >= minimumAge) {
    print("You are eligible to vote"); // This will print
  }

  int score1 = 85;
  int score2 = 90;

  if (score1 != score2) {
    print("Scores are different"); // This will print
  }

  String name1 = "Usman";
  String name2 = "Usman";

  if (name1 == name2) {
    print("Names are the same"); // This will print
  }

  //4)Logical operators -> &, ||, !
  //Example
  int Age = 25;
  bool hasLicense = true;
  bool isInsured = true;

  // AND operator
  print("---------Logical Operator-------");
  if (Age > 18 && hasLicense && isInsured) {
    print("Can drive legally");
  }

  // OR operator
  if (age < 16 || Age > 65) {
    print("Special driving rules apply");
  }

  // NOT operator
  /*if (!isRaining) {
    print("Weather is clear");
  }
*/
  //5)Ternary operator: -> ? :
  //Example
  int Score = 75;
  String result = Score >= 60 ? "Pass" : "Fail";
  print("--------Ternary Operator-------");
  print(result); // Output: Pass

  //Nested
  int marks = 85;
  String grade = marks >= 90
      ? "A"
      : marks >= 80
      ? "B"
      : marks >= 70
      ? "C"
      : "F";
  print(grade); // Output: B
}
