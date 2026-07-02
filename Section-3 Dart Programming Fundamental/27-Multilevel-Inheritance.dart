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
