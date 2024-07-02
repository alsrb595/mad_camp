// import 'package:flutter/material.dart';
// import 'phone_tab.dart';
// import 'data_model.dart';
// import 'package:provider/provider.dart';
//
// class DtModel extends ChangeNotifier {
//   List<String> _del_names = [];
//
//   List<String> get del_names => _del_names;
//
//   void removeFolder(BuildContext context, Set<int> indexes, List<Contact> contacts) {
//     _del_names = indexes.map((index) => contacts[index].name).toList();
//     notifyListeners();
//   }
//
//   void clearDelNames() {
//     _del_names.clear();
//     notifyListeners();
//   }
// }