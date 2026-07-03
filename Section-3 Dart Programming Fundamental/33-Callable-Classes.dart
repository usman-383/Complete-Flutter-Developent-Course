/*
To direct access a class we use callable classes

*/

class Test {
  // add(int a,int b){
  //   int sum =  a+b;
  //   print("Sum: $sum");
  // }

  call() {
    print("This is callable class");
  }
}

void main() {
  // Test obj = Test();
  // obj.add(10,20);

  Test obj = Test();
  obj();
}
