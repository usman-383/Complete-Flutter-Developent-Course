//Base class
class A {
  printA() {
    print("Class A");
  }
}

//Derived class
class B extends A {
  printB() {
    print("Class B");
  }
}

//Main function
void main() {
  B obj = B();
  obj.printA();
  obj.printB();
}
