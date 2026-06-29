void main() {
  int num1 = 20;
  int num2 = 20;

  print("-----------Arithmetic Operator---------");
  print("Addition :${num1 + num2}");
  print("Multiplication :${num1 * num2}");
  print("Subtraction :${num1 - num2}");
  print("Division :${num1 / num2}");
  print("Reminder :${num1 % num2}");

  int Score = 0;
  Score += 10;
  Score -= 5;
  Score *= 5;

  print("-------------Assignment Operator-------------");
  print("Final Score :${Score}");

  int Num1 = 10;
  int Num2 = 20;

  print("---------Relational Operator---------");
  if (Num1 > Num2) {
    print("Num1 Is Greater $Num1");
  } else if (Num1 < Num2) {
    print("Num2 is greater $Num2");
  } else {
    print("Both are equal $Num1 = $Num2");
  }

  int Num3 = 5;
  int Num4 = 10;

  print("--------Logical Operatoe----------");
  if (Num3 >= 5 && Num4 <= 10) {
    print("Number is between 5 and 10");
  } else if (Num3 >= 5 || Num4 > 10) {
    print("Only one condition is true");
  }
  /*else if (!Num4 > 10) {
    print("Not operator");
  }*/

  int Num5 = 5;
  String status = Num5 >= 5 ? "True" : "False";
  print("----------Ternary Operator-----------");
  print(status);

  int marks = 95;
  String statuc = marks >= 90
      ? "A"
      : marks >= 80 && marks < 90
      ? "B"
      : marks >= 70 && marks < 80
      ? "C"
      : marks >= 60 && marks < 70
      ? "D"
      : "Fail";
  print("------------Nested Ternary Operator-----------");
  print(statuc);
}
