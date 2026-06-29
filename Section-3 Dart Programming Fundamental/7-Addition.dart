import 'dart:io';

void main() {
  stdout.write("Enter Num1 :");
  int num1 = int.parse(stdin.readLineSync()!);

  stdout.write("Enter Num2 :");
  int num2 = int.parse(stdin.readLineSync()!);

  int sum = num1 + num2;

  print("Sum of $num1 & $num2 is : $sum");
}
