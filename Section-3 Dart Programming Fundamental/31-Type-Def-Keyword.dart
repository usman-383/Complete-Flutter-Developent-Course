/*
Type def is a keyword in Dart that allows you to create a new name for an existing 
type. It is used to define a type alias, which can make your code more readable and
easier to understand. Type aliases can be used for classes, functions, and other types.

Used for creating user define function.

Syntax:
typedef return type functionName(parameterType parameterName);
*/

//Example1
typedef int MathOperation(int a, int b);

MathOperation first = (int a, int b) {
  print("First Function: ${a + b}");
  return a + b;
};

MathOperation second = (int a, int b) {
  print("Second Function: ${a - b}");
  return a - b;
};

//Example2
typedef Temp(int a);

First(int a) {
  print("First Function: ${a + 2}");
}

Second(int a) {
  print("Second Function: ${a - 2}");
}

void main() {
  first(10, 5);
  second(10, 5);

  Temp firstTemp = First;
  Temp secondTemp = Second;

  firstTemp(10);
  secondTemp(10);
}
