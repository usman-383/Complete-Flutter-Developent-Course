void main() {
  /*If you want to print an expression for a number of iteration
  without using multiple time.
  
  Types of loop
  1)For loop
  2)while loop
  3)do while loop
  
  1)For loop:
          Used when number of iteration already define or know
  2)While loop:
            Used when we does not know number of iteration in advance.
  3)Do while loop:
            Used when we dont know starting point and ending point
            but know to execute at least once.
  */

  //Example:
  print("-------For Loop-------");
  print("---Number from 0 to 10---");
  for (int i = 0; i <= 10; i++) {
    print("Number = $i");
  }

  print("---Number from 10 to 0---");
  for (int i = 10; i >= 0; i--) {
    print("Number = $i");
  }

  print("----While Loop----");
  print("---Number from 0 to 10");
  int i = 0;
  while (i <= 10) {
    print("Number = $i");
    i++;
  }

  print("---Number from 10 to 0---");
  int j = 10;
  while (j >= 0) {
    print("Number = $j");
    j--;
  }

  int k = 11;
  do {
    print("-----Do while loop----");
    print("At least once executed");
    k++;
  } while (k <= 10);
}
