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

  Types of inheritance:
  1. Single Inheritance: A subclass inherits from a single superclass.
  2) Multiple Inheritance: A subclass inherits from multiple 
     superclasses. (Not directly supported in Dart, but can be 
     achieved using mixins or interfaces.)
  3. Multilevel Inheritance: A subclass inherits from a superclass,
     which in turn inherits from another superclass.
  4) Hybrid Inheritance: A combination of two or more types of 
     inheritance.
  5) Hierarchical Inheritance: Multiple subclasses inherit from a 
     single superclass.
  6) Public Inheritance: The subclass inherits public members of the 
     superclass.
  7) Protected Inheritance: The subclass inherits protected members of 
     the superclass (not directly supported in Dart).
  8) Private Inheritance: The subclass inherits private members of the 
     superclass (not directly supported in Dart).
*/
// Example Single Inheritance
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
