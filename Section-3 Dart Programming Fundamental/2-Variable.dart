/*Variable:
        Namespace in dart.

Example:
        int a = 10;

Declaration:
          int a;
          string name;
          num b;

Assigning value:
            a = 10;
            name = xyz;
            b = 10.2;

Declaration & Assigning at a time.
            int a = 10;
            name = xyz;
            num = 10.2;

*/

void main() {
  //Types of variables.

  //1)Int.
  int a;
  a = 10;
  print(a);

  //2)String
  String name;
  name = "XYZ";
  print(name);

  //3)Char
  String ch;
  ch = 'X';
  print(ch);

  //4)num;
  num n;
  n = 10;
  print(n);

  n = 10.5;
  print(n);

  //5)BigInt
  BigInt b;
  b = BigInt.parse('1111123456789098765432');
  print(b);

  //6)Double;
  double d;
  d = 10.0;
  print(d);

  //7)Bool
  bool isTrue;
  isTrue = true;
  print(isTrue);
}
