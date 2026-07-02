/*
Private inheritance is not supported in Dart. 
All class extension is effectively public inheritance. 
*/

class Parent {
  int _privateData = 10; // library-private
}

class Child extends Parent {
  void show() {
    print(_privateData); // OK if in same library/file
  }
}

void main() {
  Child obj = Child();
  obj.show();
}
