void main() {
  /*
  Collection:
          Set of objects 
  1)List : -> Store values in ordered way
      .)Static list: -> Values remain fixed
      .)Dynamic list: -> Values can be change
  */

  //Example:
  List<int> listNo = [1, 2, 3, 4, 5];

  //Some Commands
  listNo.add(6);
  listNo.remove(3);
  listNo.removeAt(0);
  listNo.contains(3);
  listNo.length;
  listNo.isEmpty;
  listNo.isNotEmpty;
  listNo.insert(0, 2);
  listNo.insertAll(0, [-5, -4, -3, -2, -1]);
  listNo.first;
  listNo.last;
}
