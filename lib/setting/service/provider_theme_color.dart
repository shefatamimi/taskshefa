import 'package:flutter/material.dart';

class  ProviderThemeColor extends ChangeNotifier{
  Color _color = Colors.blue;
  Color get color => _color;

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
  void toggleColor() {
    _color = _color == Colors.blue ? Colors.green : Colors.blue;
    notifyListeners();

  }
}




