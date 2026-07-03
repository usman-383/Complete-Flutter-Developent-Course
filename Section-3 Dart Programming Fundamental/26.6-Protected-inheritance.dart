/*
Dart does not have a real protected keyword like some other languages.

Instead:

use extends for inheritance
annotate members with @protected from package:meta
*/

import 'package:meta/meta.dart';

class Parent {
  @protected
  int protectedValue = 42;

  void doSomething() {
    print('Parent does something with $protectedValue');
  }
}

class Child extends Parent {
  void showValue() {
    print('Child can access protectedValue: $protectedValue');
  }
}

void main() {
  final child = Child();
  child.showValue();
  // child.protectedValue; // analyzer warning if used outside subclass
}
