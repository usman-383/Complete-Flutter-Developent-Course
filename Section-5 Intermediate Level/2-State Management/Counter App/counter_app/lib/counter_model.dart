import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier {
  //Private variable to hold the counter value
  int _counter = 0;

  //Getter to access the counter value
  int get count => _counter;

  //Method to increment the counter value
  void increment() {
    _counter++;

    notifyListeners();
  }
}
