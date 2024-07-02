import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'main.dart';

void main() {
  runApp(MyApp());
}

class PhoneTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Pretendard',
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            color: Colors.white,
          )
      ),
      home: PT(),
    );
  }
}

class PT extends StatefulWidget {
  const PT({super.key});

  @override
  _PhoneTabState createState() => _PhoneTabState();
}

class _PhoneTabState extends State<PT> {
  List<Contact> _contacts = [];
  bool _selectionMode = false;
  Set<int> _selectedIndexes = Set();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsString = prefs.getString('contacts');
    if (contactsString != null && contactsString.isNotEmpty) {
      List<dynamic> contactsJson = json.decode(contactsString);
      setState(() {
        _contacts = contactsJson.map((json) => Contact.fromJson(json)).toList();
      });
    } else {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    String initialData = await rootBundle.loadString('assets/json/friends.json');
    List<dynamic> initialDataJson = json.decode(initialData);
    setState(() {
      _contacts = initialDataJson.map((json) => Contact.fromJson(json)).toList();
      _saveContacts();
    });
  }

  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsJson = _contacts.map((contact) => json.encode(contact.toJson())).toList();
    prefs.setString('contacts', json.encode(contactsJson));
  }

  void _addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
      _saveContacts();
    });
  }

  void _deleteSelectedContacts() {
    setState(() {
      _contacts = _contacts
          .asMap()
          .entries
          .where((entry) => !_selectedIndexes.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
      _selectedIndexes.clear();
      _selectionMode = false;
      _saveContacts();
    });
  }

  Future<void> _showAddContactDialog() async {
    String name = '';
    String contact = '';
    String id = '';
    String location = '';
    String character = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Contact'),
                  onChanged: (value) {
                    contact = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'ID'),
                  onChanged: (value) {
                    id = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Location'),
                  onChanged: (value) {
                    location = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Character'),
                  onChanged: (value) {
                    character = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addContact(Contact(
                  name: name,
                  contact: contact,
                  id: id,
                  location: location,
                  character: character,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone"),
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(_selectionMode ? Icons.delete : Icons.check),
            onPressed: () {
              if (_selectionMode) {
                _deleteSelectedContacts();
              } else {
                setState(() {
                  _selectionMode = true;
                });
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.add),
        onPressed: _showAddContactDialog,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 1.0,
          ),
          itemCount: _contacts.length,
          itemBuilder: (context, index) {
            final contact = _contacts[index];
            final isSelected = _selectedIndexes.contains(index);
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  _selectionMode = true;
                  _selectedIndexes.add(index);
                });
              },
              onTap: () {
                if (_selectionMode) {
                  setState(() {
                    if (isSelected) {
                      _selectedIndexes.remove(index);
                    } else {
                      _selectedIndexes.add(index);
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${contact.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: ImageIcon(
                            contact.contact == 'instagram'
                                ? AssetImage('assets/logos/instagram.png')
                                : contact.contact == 'facebook'
                                ? AssetImage('assets/logos/facebook.png')
                                : contact.contact == 'twitter'
                                ? AssetImage('assets/logos/twitter.png')
                                : contact.contact == 'kakao'
                                ? AssetImage('assets/logos/kakao.png')
                                : contact.contact == 'line'
                                ? AssetImage('assets/logos/LINE.png')
                                : contact.contact == 'wechat'
                                ? AssetImage('assets/logos/wechat.png')
                                : contact.contact == 'whatsapp'
                                ? AssetImage('assets/logos/whatsapp.png')
                                : contact.contact == 'phone'
                                ? AssetImage('assets/logos/phone.png')
                                : AssetImage('assets/logos/default.png'),
                            size: 30,
                          ),
                          onPressed: () {
                            print('Icon pressed');
                          },
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                              contact.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      contact.location,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    Text(contact.character),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Contact {
  final String name;
  final String contact;
  final String id;
  final String location;
  final String character;

  Contact({
    required this.name,
    required this.contact,
    required this.id,
    required this.location,
    required this.character,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      contact: json['contact'],
      id: json['id'],
      location: json['location'],
      character: json['character'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'id': id,
      'location': location,
      'character': character,
    };
  }
}
