void main() {
  /*
  Sets: 
      Store data in unordered way. We store unique value in sets.
  */

  //Example
  Set items = {1, 2, 3, 4, 5};
  print(items);

  Set items1 = {6, 7, 8, 9};
  print(items1);

  //Simple Commands
  items.first;
  items.add(6);
  items.isEmpty;
  items.isNotEmpty;
  items.last;
  items.length;
  items.contains(6);
  items.elementAt(0);
  items.remove(3);
  items.addAll(items1);
}
