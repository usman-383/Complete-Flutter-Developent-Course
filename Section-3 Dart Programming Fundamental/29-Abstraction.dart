/*
Abstraction is a process of hiding the implementation details and showing only 
functionality to the user. In other words, it shows only essential things to the 
user and hides the internal details, i.e., it shows what an object does instead of 
how it does it.:
              
*/

//Example1
abstract class Human {
  Eyes();
}

class Male extends Human {
  @override
  Eyes() {
    print("For Male, Eyes");
  }
}

class Female extends Human {
  @override
  Eyes() {
    print("For Female, Eyes");
  }
}

void main() {
  Male obj1 = Male();
  obj1.Eyes();

  Female obj2 = Female();
  obj2.Eyes();
}
