import 'package:flutter/material.dart';
import 'phone_tab.dart';

class DataModel extends ChangeNotifier {
  List<String> _folders = [];

  List<String> get folders => _folders;

  void addFolder(Contact contact) {
    _folders.add(contact.name);
    notifyListeners();
  }
} // 2, 1,3 이라는 인덱스는 제대로 들어옴
// 인덱스랑 폴더즈의 네임에 매칭하는 리스트를 사용