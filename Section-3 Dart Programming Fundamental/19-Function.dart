import 'dart:io';
/*Function
        :A block of code that is used for performing a specific task

Types of function:
1)Void function
2)Setter function
2)Getter function
3)Parameterless function
4)Parameterize function
*/

//Setter function
void set(String name) {
  name = name;
}

//Getter function
int get() {
  stdout.write("Enter number :");
  int num = int.parse(stdin.readLineSync()!);
  print(num);

  return num;
}

//Void or main function
void main() {
  print("----Main Function----");
  stdout.write("Enter First Number :");
  int num1 = int.parse(stdin.readLineSync()!);

  stdout.write("Enter Second Number :");
  int num2 = int.parse(stdin.readLineSync()!);

  int sum = num1 + num2;
  print("Sum of $num1 & $num2 is : $sum");
  print("---------------------");

  //Getter function
  print("----Getter Function----");
  get();
  print("-----------------------");

  //setter function
  print("----setter Function----");
  set("Usman");
  print("-----------------------");
}
