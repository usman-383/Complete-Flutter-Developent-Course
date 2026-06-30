import 'dart:io';

void main() {
  //Example
  stdout.write("Enter your numbers :");

  int num = int.parse(stdin.readLineSync()!);

  if (num >= 90 || num <= 100) {
    print("A grade");
  } else if (num >= 80 || num < 90) {
    print("B grade");
  } else if (num >= 70 || num < 80) {
    print("C grade");
  } else if (num >= 60 || num < 70) {
    print("D grade");
  } else {
    print("Fail");
  }

  //Example2
  stdout.write("Enter Number :");
  int num1 = int.parse(stdin.readLineSync()!);

  //  int even = 0;
  //  int odd = 0;

  if (num1 % 2 == 0) {
    print("Even number");
    // even++;
  } else {
    print("Odd number");
    // odd++;
  }

  // print("Total Even number entered : $even");
  // print("Total odd number entered : $odd");
}
