/*
Setter and Getter in Dart:
                    Specifically, Dart provides a way to define custom behavior
when getting or setting a property of an object. This is done using getter and 
setter methods.

.)They are special function that provide read & write access to the object properties.
*/

class Student {
  String _name = "John"; // private variable

  // Getter method
  String get name {
    return this._name; //Private variable is accessed using getter method
  }

  // Setter method
  set name(String name) {
    this._name = name;
  }
}

void main() {
  Student obj = Student();
  obj.name = "Alice"; // Using setter to set the name
  print(obj.name); // Using getter to get the name
}
