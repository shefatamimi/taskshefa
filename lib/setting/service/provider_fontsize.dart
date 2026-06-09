import 'package:flutter/material.dart';

class FontSizeController extends ChangeNotifier {

  double value = 20.0;

  void increment() {
    value++;
    notifyListeners();
  }

  void decrement() {
    value--;
    notifyListeners();
  }

}