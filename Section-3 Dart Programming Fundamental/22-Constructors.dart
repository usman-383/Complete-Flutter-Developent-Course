/*
Constructor:
            Constructor are special function
            .)Name are same as class.
            .)When class is instantiated constructor is called automatically.
            .)Constructor can be overloaded.
            .)Constructor does not have return type. 

            Types of Constructor:
            1)Default Constructor
            2)Parameterized Constructor
            3)copy Constructor
*/
//Example
class Student {
  String? name;
  int? age;

  //Default Constructor
  Student() {
    print("Default Constructor");
  }

  //Parameterized Constructor
  Student.parameterized(String name, int age) {
    this.name = name;
    this.age = age;
    print("Parameterized Constructor");
  }

  //Copy Constructor
  Student.copy(Student s) {
    this.name = s.name;
    this.age = s.age;
    print("Copy Constructor");
  }
}

//Example2;
class Student2 {
  //Default Constructor
  Student2() {
    print("Default Constructor");
  }

  //Parameterized Constructor
  Student2.parameterized(int num1, int num2) {
    int sum = num1 + num2;
    print("Sum is: $sum");
    print("Parameterized Constructor");
  }
}

void main() {
  Student s1 = Student(); //Default Constructor
  Student s2 = Student.parameterized("John", 20); //Parameterized Constructor
  Student s3 = Student.copy(s2); //Copy Constructor

  Student2 s4 = Student2(); //Default Constructor
  Student2 s5 = Student2.parameterized(10, 20); //Parameterized Constructor
}
