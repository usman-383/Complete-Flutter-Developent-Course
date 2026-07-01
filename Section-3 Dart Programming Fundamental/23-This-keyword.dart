/*
This keyword:
          This keyword is used to refer to the current
          instance of the class. It is used to access the instance
          variables and methods of the class.

          .)It is also used for accessing global keywords and 
          methods of the class.
*/
//Example 1: Accessing instance variables and methods of the class
class Student {
  String? name;
  int? age;

  //Instance variables and methods of the class
  void display() {
    print("Name: $name");
    print("Age: $age");
  }

  //Example 2: Accessing global keywords and methods of the class
  void Display(String name, int age) {
    this.name = name;
    this.age = age;
    print("Name: $name");
    print("Age: $age");
  }
}

void main() {
  //Without using this keyword
  Student s1 = Student();
  s1.name = "John";
  s1.age = 20;
  s1.display();

  //Using this keyword
  Student s2 = Student();
  s2.Display("Doe", 25);
}
