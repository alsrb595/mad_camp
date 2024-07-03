// import 'package:flutter/material.dart';
// import 'gallery_tab.dart';
// import 'phone_tab.dart';
// import 'data_model.dart';
// import 'package:provider/provider.dart';
//
// class DtModel extends ChangeNotifier {
//   List<String> _del_names = [];
//
//   List<String> get del_names => _del_names;
//
//   void removeFolder(Set<int> indexes) {
//     FolderPageState state = FolderPageState();
//     for(var i in indexes) {
//       del_names.add(state.folders[i]);
//     }
//     print(del_names);
//     notifyListeners();
//   }
//
//   void clearDelNames() {
//     _del_names.clear();
//     notifyListeners();
//   }
// }