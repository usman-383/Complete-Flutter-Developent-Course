import 'dart:io';

void main() {
  //Switch case is used whenever we have a lot of conditions

  //Example.
  print("--------- Menu---------");
  print("1.For Addition");
  print("2.For Subtraction");
  print("3.For Multiplication");
  print("4.For Division");
  print("-------------------------");

  stdout.write("Enter Your Choice :");
  int choice = int.parse(stdin.readLineSync()!);

  switch (choice) {
    case 1:
      stdout.write("Enter first number :");
      int num1 = int.parse(stdin.readLineSync()!);

      stdout.write("Enter second number :");
      int num2 = int.parse(stdin.readLineSync()!);

      int sum = num1 + num2;
      print(sum);

      break;

    case 2:
      stderr.write("Enter first number :");
      int num1 = int.parse(stdin.readLineSync()!);

      stdout.write("Enter second number :");
      int num2 = int.parse(stdin.readLineSync()!);

      int diff = num1 - num2;
      print(diff);

      break;

    case 3:
      stdout.write("Enter first number :");
      int num1 = int.parse(stdin.readLineSync()!);

      stdout.write("Enter second number :");
      int num2 = int.parse(stdin.readLineSync()!);

      int mul = num1 * num2;
      print(mul);

      break;

    case 4:
      stdout.write("Enter first number :");
      int num1 = int.parse(stdin.readLineSync()!);

      stdout.write("Enter second number :");
      int num2 = int.parse(stdin.readLineSync()!);

      int div = num1 ~/ num2;
      print(div);

      break;

    default:
      print("You entered wrong choice, please enter right choice.");
  }
}
