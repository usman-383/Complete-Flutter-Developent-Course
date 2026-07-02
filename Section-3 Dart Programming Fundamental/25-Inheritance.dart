/*
Inheritance:
          
  Inheritance is a mechanism in object-oriented programming that
  allows a class to inherit properties and behaviors (methods) 
  from another class. The class that inherits is called the 
  subclass (or derived class), and the class being inherited 
  from is called the superclass (or base class). 
  Inheritance promotes code reusability and establishes a 
  hierarchical relationship between classes.

  In Dart, inheritance is achieved using the "extends" keyword.
  A subclass can access public and protected members of its 
  superclass, but it cannot access private members.
*/
// Example:

class Animal {
  void eat() {
    print("Animal is eating");
  }
}

class Dog extends Animal {
  void bark() {
    print("Dog is barking");
  }
}

void main() {
  Dog dog = Dog();
  dog.eat(); // Inherited method from Animal
  dog.bark(); // Method from Dog
}
