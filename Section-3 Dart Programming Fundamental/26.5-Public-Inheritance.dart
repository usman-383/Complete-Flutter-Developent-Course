/*
Dart does not have a public keyword for inheritance. 
All class extension is effectively public inheritance.
*/

class Animal {
  void eat() {
    print('Animal is eating');
  }
}

class Dog extends Animal {
  void bark() {
    print('Dog is barking');
  }
}

void main() {
  final dog = Dog();
  dog.eat(); // inherited publicly from Animal
  dog.bark();
}
