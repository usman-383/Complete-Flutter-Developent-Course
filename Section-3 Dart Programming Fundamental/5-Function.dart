/*
Function:


*/

void main() {
  print("-------------Function 1------------------");
  fun1();

  print("-------------Function 2------------------");
  fun2("Usman");

  print("-------------Function 3------------------");
  fun3(3, 5);

  print("-------------Function 4-------------------");
  print(get1(5));

  print("-------------Function 5-------------------");
  print(get2("Usman"));
}

//1)Parameterless Function
void fun1() {
  print("Parameterless Function");
}

//2)Paraeterize Function
void fun2(String name) {
  print("Hello $name");
}

void fun3(int num1, int num2) {
  print("The addition of $num1 & $num2 is: ${num1 + num2}");
}

//Getter Function
int get1(int num1) {
  print("This is a getter function");
  return num1;
}

String get2(String name) {
  print("This is a getter function");
  return name;
}
