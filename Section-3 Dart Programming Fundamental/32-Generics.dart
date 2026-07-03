/*
Generics:

*/

class Test {
  //Non Generic List
  list() {
    List<dynamic> listContent = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10.5];
    print(listContent);

    listContent.length;
    listContent.add("XYZ");
    print(listContent);
  }

  //Generic List
  list1() {
    List<int> listContent = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    print(listContent);

    listContent.length;
    listContent.add(11);
    print(listContent);
  }
}

void main() {
  Test obj = Test();
  obj.list();

  obj.list1();
}
