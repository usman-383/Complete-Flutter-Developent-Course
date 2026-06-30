import 'dart:io';
/*
Class:
    Class is a structure, blueprint or model.

    class structure.
    1)Class keyword followed by class name and {}.
    2)Inside class there is functions, methods, constructor, variables, and destructor.

*/

//Example
class Test {
  Add() {
    stdout.write("Enter First Number :");
    int num1 = int.parse(stdin.readLineSync()!);

    stdout.write("Enter Second Number :");
    int num2 = int.parse(stdin.readLineSync()!);

    int sum = num1 + num2;

    print(sum);
  }
}

void main() {
  Test t = Test();
  t.Add();
}
