/*
Exception Handling:
                Handle error whenever it occurs in the program.
It is a process of responding to the occurrence of exceptions during the execution 
of a program. Exception handling is a mechanism to handle runtime errors, 
so that the normal flow of the application can be maintained.

Syntax:
try {
  // code that may throw an exception
} catch (e) {
  // code to handle the exception
} finally {
  // code that will always execute, regardless of whether an exception occurred or not
}

//Types of Exception Handling:
1. Try-Catch Block: It is used to catch exceptions that may occur in the try block.
 The catch block is executed if an exception occurs in the try block.
2. Try-Catch-Finally Block: It is used to catch exceptions that may occur in the 
try block and execute the finally block regardless of whether an exception occurred
 or not.

*/

//Example1
class Test {
  div() {
    int x = 5 ~/ 0;
    print(x);
  }
}

void main() {
  Test obj = Test();
  try {
    obj.div();
  } catch (e) {
    print("Exception Caught: $e");
  } finally {
    print("Finally block executed");
  }
}
