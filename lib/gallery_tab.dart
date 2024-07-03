import 'dart:convert';
import 'dart:typed_data';
import 'main.dart';
import 'dt_model.dart';
import 'data_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class GalleryTab extends StatelessWidget {
  const GalleryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Gallery App',
      theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'Pretendard',
          primarySwatch: Colors.blue,
          // appBarTheme: AppBarTheme(
          //   color: Colors.white,
          // )
      ),
      home: const FolderPage(),
    );
  }
}

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => FolderPageState();
}

class FolderPageState extends State<FolderPage> {
  List<String> _folders = [];
  final ImagePicker _picker = ImagePicker();
  bool _selectionMode = false;
  List<int> _selectedIndexes = [];
  List<String> del_folders = [];
  @override
  void initState() {
    super.initState();
    final dataModel = Provider.of<DataModel>(context, listen: false).addListener(_onDataChanged);
    // final dtModel = Provider.of<DtModel>(context, listen: false).addListener(_onDataDeleted);
    _loadFolders();
  }

  // void _onDataDeleted(){
  //   del_folders = Provider.of<DtModel>(context, listen: false).del_names;
  //   print(del_folders);
  //   if (del_folders.isNotEmpty) {
  //     _deleteFolders();
  //   }
  // }


  Future<void> _loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? loadedFolders = prefs.getStringList('folders');
    if (loadedFolders != null) {
      setState(() {
        _folders = loadedFolders;
      });
    }
  }

  Future<void> _saveFolders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('folders', _folders);
  }

  Future<void> _deleteSelectedFolders() async {
    //_selectedIndexes.sort((a, b) => b.compareTo(a));
    final prefs = await SharedPreferences.getInstance();
    for (var index in _selectedIndexes) {
      String folderName = _folders[index];
      _folders.removeAt(index);
      await prefs.remove(folderName);
    }
    setState(() {
      _selectedIndexes.clear();
      _selectionMode = false;
    });
    await _saveFolders();
  }

  Future<void> _deleteFolders() async {
    final prefs = await SharedPreferences.getInstance();
    for (var name in del_folders) {
      _folders.remove(name);
      await prefs.remove(name);
    }
    del_folders.clear();

    setState(() {
      _selectedIndexes.clear();
      _selectionMode = false;
    });
    await _saveFolders();
    //
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedIndexes.clear();
      }
    });
  }

  @override
  void dispose() {
    final dataModel = Provider.of<DataModel>(context, listen: false);
    dataModel.removeListener(_onDataChanged);

    // final dtModel = Provider.of<DtModel>(context, listen: false);
    // dtModel.removeListener(_onDataDeleted);
    super.dispose();
  }


  void _onDataChanged() {
    final dataModel = Provider.of<DataModel>(context, listen: false);
    String newFolderName = Provider.of<DataModel>(context, listen: false).folders.last;
    _addEmptyFolder(newFolderName);

  }

  Future<void> _addEmptyFolder(String folderName) async {
    if (folderName.isNotEmpty) {
      List<String> base64List = [];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(folderName, base64List);
      setState(() {
        _folders.add(folderName);
      });
      await _saveFolders();
    }
  }

  Future<void> _addFolderWithImages(String folderName, List<XFile> images) async {
    if (folderName.isNotEmpty) {
      List<String> base64List = [];
      for (var file in images) {
        Uint8List bytes = await file.readAsBytes();
        String base64String = base64Encode(bytes);
        base64List.add(base64String);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(folderName, base64List);

      setState(() {
        _folders.add(folderName);
      });
      await _saveFolders();
    }
  }

  void _showAddFolderDialog() {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(
              labelText: 'Folder Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String folderName = folderNameController.text;
                Navigator.of(context).pop();
                //_pickImages(folderName);
                _addEmptyFolder(folderName);
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImages(String folderName) async {
    try {
      final List<XFile>? pickedFileList = await _picker.pickMultiImage();
      if (pickedFileList != null && pickedFileList.isNotEmpty) {
        await _addFolderWithImages(folderName, pickedFileList);
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  Future<String?> _getFirstImage(String folderName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? images = prefs.getStringList(folderName);
    return images?.isNotEmpty == true ? images![0] : null;
  }

  Future<void> _navigateToGallery(String folderName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPage(folderName: folderName),
      ),
    );

    if (result == true) {
      _loadFolders();  // 이미지 변경 시 폴더 리스트 갱신
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
              'Folders',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/appBar.png'),
                  fit: BoxFit.cover,
                )
            ),
          ),



          actions: [
            IconButton(
              icon: Icon(_selectionMode ? Icons.close : Icons.check),
              onPressed: _toggleSelectionMode,
            ),
            if (_selectionMode && _selectedIndexes.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await _deleteSelectedFolders();
                },
              ),
          ],
        ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: _folders.isNotEmpty
                  ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: _folders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (_selectionMode) {
                        _toggleSelection(index);
                      } else {
                        _navigateToGallery(_folders[index]);
                      }
                    },
                    onLongPress: () {
                      if (!_selectionMode) {
                        _toggleSelectionMode();
                        _toggleSelection(index);
                      }
                    },
                    child: Stack(
                      children: [
                        FutureBuilder<String?>(
                          future: _getFirstImage(_folders[index]),
                          builder: (context, snapshot) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4.5),
                              child: Container(
                                color: Colors.grey[300],
                                child: snapshot.hasData
                                    ? Image.memory(
                                  base64Decode(snapshot.data!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: _selectedIndexes.contains(index)
                                      ? Colors.black.withOpacity(0.5)
                                      : null,
                                  colorBlendMode: _selectedIndexes.contains(index)
                                      ? BlendMode.darken
                                      : null,
                                )
                                    : null,
                                // : Center(child: Text(_folders[index])),
                              ),
                            );
                          },
                        ),
                        if (_selectedIndexes.contains(index))
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                          ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.5),
                              //color: Colors.white54,
                              color: Colors.black26,
                            ),
                            child: Center(
                              child: Text(
                                _folders[index],
                                style: TextStyle(
                                  //color: Colors.black,
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Center(
                child: Text('No folders created.'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFolderDialog,
        tooltip: 'Add Folder',
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}

class GalleryPage extends StatefulWidget {
  final String folderName;

  const GalleryPage({Key? key, required this.folderName}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imageBase64List = [];
  List<int> _selectedIndexes = [];
  bool _selectionMode = false;
  bool _imagesChanged = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _loadImages();
  }

  Future<void> _requestPermission() async {
    if (await Permission.storage.isGranted) {
      return;
    }
    await Permission.storage.request();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFileList = await _picker.pickMultiImage();
      if (pickedFileList != null) {
        List<String> base64List = [];
        for (var file in pickedFileList) {
          Uint8List bytes = await file.readAsBytes();
          String base64String = base64Encode(bytes);
          base64List.add(base64String);
        }
        setState(() {
          _imageBase64List.addAll(base64List);
          _imagesChanged = true; // 이미지가 변경되었음을 표시
        });
        await _saveImages();
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.folderName, _imageBase64List);
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? loadedImages = prefs.getStringList(widget.folderName);
    if (loadedImages != null) {
      setState(() {
        _imageBase64List = loadedImages;
      });
    }
  }

  Future<void> _deleteSelectedImages() async {
    setState(() {
      _selectedIndexes.sort((a, b) => b.compareTo(a));
      for (var index in _selectedIndexes) {
        _imageBase64List.removeAt(index);
      }
      _selectedIndexes.clear();
      _selectionMode = false;
      _imagesChanged = true; // 이미지가 변경되었음을 표시
    });
    await _saveImages();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedIndexes.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _imagesChanged); // 이미지가 변경되었는지 여부 반환
        return false; // 기본 뒤로가기 동작을 방지
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(1.0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(35.0),
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(1.0),
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                widget.folderName,
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
            leadingWidth: 50.0,
            leading: IconButton(
              icon: Image.asset('assets/icons/back.png'),
              onPressed: () {
                Navigator.pop(context, _imagesChanged);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(_selectionMode ? Icons.close : Icons.check),
                onPressed: _toggleSelectionMode,
              ),
              if (_selectionMode && _selectedIndexes.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _deleteSelectedImages();
                  },
                ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(3.0),
          child: _imageBase64List.isNotEmpty
              ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            itemCount: _imageBase64List.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (_selectionMode) {
                    _toggleSelection(index);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                          imageBase64List: _imageBase64List,
                          initialIndex: index,
                        ),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  if (!_selectionMode) {
                    _toggleSelectionMode();
                    _toggleSelection(index);
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.memory(
                        base64Decode(_imageBase64List[index]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        color: _selectedIndexes.contains(index)
                            ? Colors.black.withOpacity(0.5)
                            : null,
                        colorBlendMode: _selectedIndexes.contains(index)
                            ? BlendMode.darken
                            : null,
                      ),
                    ),
                    if (_selectedIndexes.contains(index))
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              );
            },
          )
              : Center(
            child: Text('No images selected.'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickImages,
          tooltip: 'Pick Images',
          child: const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final List<String> imageBase64List;
  final int initialIndex;

  const ImageDetailScreen({
    Key? key,
    required this.imageBase64List,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/appBar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      body: PageView.builder(
        controller: pageController,
        itemCount: imageBase64List.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.memory(base64Decode(imageBase64List[index])),
          );
        },
      ),
    );
  }
}
