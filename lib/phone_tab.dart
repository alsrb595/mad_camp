import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'data_model.dart';
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
          )),
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
  List<Contact> _filteredContacts = [];
  bool _selectionMode = false;
  Set<int> _selectedIndexes = Set();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsString = prefs.getString('contacts');
    if (contactsString != null && contactsString.isNotEmpty) {
      List<dynamic> contactsJson = json.decode(contactsString);
      setState(() {
        _contacts = contactsJson.map((json) => Contact.fromJson(json)).toList();
        _filteredContacts = _contacts;
      });
    }
  }

  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> contactsJson = _contacts.map((contact) => contact.toJson()).toList();
    prefs.setString('contacts', json.encode(contactsJson));
  }

  void _addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
      _filteredContacts = _contacts;
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
      _filteredContacts = _contacts;
      _selectedIndexes.clear();
      _selectionMode = false;
      _saveContacts();
    });
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
            contact.contact.toLowerCase().contains(query) ||
            contact.id.toLowerCase().contains(query) ||
            contact.location.toLowerCase().contains(query) ||
            contact.character.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _showAddContactDialog() async {
    String name = '';
    String contact = 'phone';  // Default value
    String id = '';
    String location = '';
    String character = '';

    List<String> contactOptions = [
      'instagram',
      'facebook',
      'kakaotalk',
      'line',
      'wechat',
      'whatsapp',
      'phone',
    ];

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    DropdownButton<String>(
                      value: contact,
                      onChanged: (String? newValue) {
                        setState(() {
                          contact = newValue!;
                        });
                      },
                      items: contactOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                    Provider.of<DataModel>(context, listen: false).addFolder(name);
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
      },
    );
  }

  Future<void> _showEditContactDialog(int index) async {
    Contact contact = _contacts[index];
    TextEditingController nameController = TextEditingController(text: contact.name);
    TextEditingController idController = TextEditingController(text: contact.id);
    TextEditingController locationController = TextEditingController(text: contact.location);
    TextEditingController characterController = TextEditingController(text: contact.character);

    List<String> contactOptions = [
      'instagram',
      'facebook',
      'kakaotalk',
      'line',
      'wechat',
      'whatsapp',
      'phone',
    ];

    String dropdownValue = contact.contact;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Contact'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: contactOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(hintText: 'ID'),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(hintText: 'Location'),
                    ),
                    TextField(
                      controller: characterController,
                      decoration: InputDecoration(hintText: 'Character'),
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
                  child: Text('Save'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _contacts[index] = Contact(
                        name: nameController.text,
                        contact: dropdownValue,
                        id: idController.text,
                        location: locationController.text,
                        character: characterController.text,
                      );
                      _filteredContacts = _contacts;
                      _saveContacts();
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1.0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Friends',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemCount: _filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedIndexes.contains(index);
                  return GestureDetector(
                    onLongPress: () {
                      _showEditContactDialog(index);
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
                          SizedBox(height: 0.0),
                          Text(
                            '${contact.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                          SizedBox(height: 0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: ImageIcon(
                                  contact.contact == 'instagram' || contact.contact == 'insta'
                                      ? AssetImage('assets/logos/instagram.png')
                                      : contact.contact == 'facebook'
                                      ? AssetImage('assets/logos/facebook.png')
                                      : contact.contact == 'kakaotalk' || contact.contact == 'kakao'
                                      ? AssetImage('assets/logos/kakao.png')
                                      : contact.contact == 'line'
                                      ? AssetImage('assets/logos/LINE.png')
                                      : contact.contact == 'wechat'
                                      ? AssetImage('assets/logos/wechat.png')
                                      : contact.contact == 'whatsapp'
                                      ? AssetImage('assets/logos/whatsapp.png')
                                      : contact.contact == 'phone'
                                      ? AssetImage('assets/logos/phone.png')
                                      : AssetImage('assets/logos/phone.png'),
                                  size: 25,
                                ),
                                onPressed: () {
                                  print('Icon pressed');
                                },
                              ),
                              SizedBox(width: 0),
                              Text(
                                contact.id,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            contact.location,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            contact.character,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.add),
        onPressed: _showAddContactDialog,
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
