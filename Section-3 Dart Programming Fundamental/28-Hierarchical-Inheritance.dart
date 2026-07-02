/*
Hierarchical Inheritance: When multiple derived classes are created from a 
single base class, it is known as hierarchical inheritance. 
In this type of inheritance, the base class is inherited by multiple
derived classes. Each derived class can have its own unique properties
and methods, while also inheriting the properties and methods of the 
base class.
*/

//Base class
class A {
  printA() {
    print("Class A");
  }
}

//Derived class1
class B extends A {
  printB() {
    print("Class B");
  }
}

//Derived class2
class C extends A {
  printC() {
    print("Class C");
  }
}

//Main function
void main() {
  B obj1 = B();
  obj1.printA();
  obj1.printB();

  C obj2 = C();
  obj2.printA();
  obj2.printC();
}
