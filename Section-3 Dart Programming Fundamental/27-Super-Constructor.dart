/*
Super constructor:
                To extent parent class properties into child class
*/
//Example

class Super {
  Super() {
    print("Super constructor");
  }
}

class Child extends Super {
  Child() {
    print("Child constructor");
  }
}

void main() {
  Child Obj = Child();
}
