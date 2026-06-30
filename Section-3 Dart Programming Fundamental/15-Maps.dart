void main() {
  /*
Maps:
    In maps we store data in unordered way.
    Contain in pairs form(key and value).
    Key will be unique
*/

  //Example
  Map<String, int> mapData = {"A": 1, "B": 2, "C": 3};

  print(mapData);

  //Example2
  Map<String, dynamic> mapData2 = {"A": 1, "B": '2', "C": "xyz", "D": 10.5};
  print(mapData2);

  //Simple Commands
  mapData2["D"] = ["Hello"];
  mapData2.keys;
  mapData2.values;
  mapData2.length;
  mapData2.isEmpty;
  mapData.isNotEmpty;
  mapData2.remove("A");
  mapData2.addAll(mapData);
}
