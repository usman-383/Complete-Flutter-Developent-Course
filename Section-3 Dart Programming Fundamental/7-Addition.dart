import 'dart:io';

void main() {
  //First number
  stdout.write("Enter Num1 :");
  int num1 = int.parse(stdin.readLineSync()!);

  //Second number
  stdout.write("Enter Num2 :");
  int num2 = int.parse(stdin.readLineSync()!);

  //sum of num1 and num2
  int sum = num1 + num2;

  //Output of sum
  print("Sum of $num1 & $num2 is : $sum");
}
