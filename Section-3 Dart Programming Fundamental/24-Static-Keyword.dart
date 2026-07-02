/*
Static:
    Static keyword is a reserve word which is used for regaining its
    value and is used to class level.

    .)Value remains fixed.
    .)Provide global access

*/
//Example.
import 'dart:io';

class Addition {
  static add() {
    print("------Addition------");
    stdout.write("Enter First Number :");
    int num1 = int.parse(stdin.readLineSync()!);

    stdout.write("Enter Second Number :");
    int num2 = int.parse(stdin.readLineSync()!);

    int sum = num1 + num2;

    print(sum);
  }
}

class Subclass {
  test() {
    print("------Subclass------");
    Addition.add();
  }
}

void main() {
  Addition.add();

  Subclass obj = Subclass();
  obj.test();
}
