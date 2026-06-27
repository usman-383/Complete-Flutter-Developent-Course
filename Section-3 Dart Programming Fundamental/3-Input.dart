import 'dart:io';

void main() {
  //Print
  stdout.write("Enter Your Name :");

  //Input
  var name = stdin.readLineSync();

  //Output
  print("Welcome 👋: $name");
}
