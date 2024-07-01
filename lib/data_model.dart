import 'package:flutter/material.dart';

class DataModel extends ChangeNotifier {
  List<String> _folders = [];

  List<String> get folders => _folders;

  void addFolder(String name) {
    _folders.add(name);
    notifyListeners();
  }
}