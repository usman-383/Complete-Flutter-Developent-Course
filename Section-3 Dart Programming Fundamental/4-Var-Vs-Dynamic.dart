void main() {
  /*var:
        A keyword used to declare a variable without specifying its type.
        The type of the variable is inferred from the assigned value.

        we use var in inline declaration, where we declare and assign a value to a variable at the same time.
        As first time when you give any type of value to a variable, it will be assigned that type 
        and you cannot change it later.
  */

  //inline declaration
  var name = "Alice";
  // var name = 10;
  // var name = true;

  var age = 30;
  // var age = 'khan';

  var isActive = true;
  // var isActive = 19;

  /*dynamic:
        A keyword used to declare a variable with a type that can change at runtime.
        It is similar to 'Object' in other languages.

        When you declare a variable as 'dynamic', it can hold values of any type, and 
        you can change its type at runtime.
  */

  dynamic message = "Hello, World!";
  message = 42; // Valid
  message = true; // Valid

  // practice
  /*var n = "usman";
  n = "khan";
  // n = 10;

  var m;
  m = "usman";
  m = 10;
  m = true;

  dynamic x = "usman";
  x = 10;
  x = true;

  dynamic y;
  y = "usman";
  y = 10;
  y = true;*/
}
