/*
Mutlilevel Inheritance: In multilevel inheritance, a class is derived from
 another derived class. It is a chain of inheritance. 
 In this type of inheritance, the properties and methods of the base 
 class and the derived class are inherited by the new derived class.
*/

class A {
  printA() {
    print("Class A");
  }
}

class B extends A {
  printB() {
    print("Class B");
  }
}

class C extends B {
  printC() {
    print("Class C");
  }
}

void main() {
  C obj = C();
  obj.printA();
  obj.printB();
  obj.printC();
}
