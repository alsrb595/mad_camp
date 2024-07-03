import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'data_model.dart';
import 'main.dart';
import 'dt_model.dart';
import 'dart:ui';

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
      // Provider.of<DtModel>(context, listen: false).removeFolder(_selectedIndexes);
      _selectionMode = false;
      _selectedIndexes.clear();
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
    List<String> contactList = ['Phone', 'Instagram', 'KakaoTalk', 'Facebook', 'Line', 'WhatsApp', 'WeChat'];
    String name = '';
    String contact = contactList[1];
    String id = '';
    String location = '';
    String character = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Center(
            child: Text('Add Contact'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 15),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      value: contact,
                      onChanged: (String? newValue) {
                        setState(() {
                          contact = newValue!;
                        });
                      },
                      items: contactList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      itemHeight: 50,
                    );
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    id = value;
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    location = value;
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Character',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    character = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(175, 173, 248, 1),
                    foregroundColor: Colors.white,
                  ),
                ),
                Spacer(),
                TextButton(
                  child: Text('Add'),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(175, 173, 248, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Provider.of<DataModel>(context, listen: false).addFolder(Contact(
                      name: name,
                      contact: contact,
                      id: id,
                      location: location,
                      character: character,
                    ));
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
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditContactDialog(int index) async {
    Contact contact = _contacts[index];
    TextEditingController nameController = TextEditingController(text: contact.name);
    List<String> contactList = ['Phone', 'Instagram', 'KakaoTalk', 'Facebook', 'Line', 'WhatsApp', 'WeChat'];
    String selectedContact = contact.contact; // 초기값을 contact의 값으로 설정
    TextEditingController idController = TextEditingController(text: contact.id);
    TextEditingController locationController = TextEditingController(text: contact.location);
    TextEditingController characterController = TextEditingController(text: contact.character);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Center(
            child: Text('Edit Contact'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      value: selectedContact.isEmpty ? contactList[0] : selectedContact,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedContact = newValue!;
                        });
                      },
                      items: contactList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      itemHeight: 50,
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        hintText: 'ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: characterController,
                      decoration: InputDecoration(
                        hintText: 'Character',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(175, 173, 248, 1),
                    foregroundColor: Colors.white,
                  ),
                ),
                Spacer(),
                TextButton(
                  child: Text('Save'),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(175, 173, 248, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _contacts[index] = Contact(
                        name: nameController.text,
                        contact: selectedContact,
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
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("People"),
        backgroundColor: Colors.transparent,
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
            onPressed: () {
              setState(() {
                _selectionMode = !_selectionMode;
              });
            },
          ),
          if (_selectionMode && _selectedIndexes.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteSelectedContacts();
                },
              ),


          // IconButton(
          //   icon: Icon(_selectionMode ? Icons.delete : Icons.check),
          //   onPressed: () {
          //     if (_selectionMode) {
          //       _deleteSelectedContacts();
          //     } else {
          //       setState(() {
          //         _selectionMode = true;
          //       });
          //     }
          //   },
          // ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(175, 173, 248, 1),
                  Color.fromRGBO(175, 173, 248, 0.7),
                  Color.fromRGBO(175, 173, 248, 0.1),
                ],
              ),
            ),
            padding: EdgeInsets.all(3.0),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,

                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                                child:
                                    Text(
                                      contact.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                )
                            )
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                ImageIcon(
                                  AssetImage(
                                    contact.contact.toLowerCase() == 'instagram' || contact.contact.toLowerCase() == 'insta'
                                        ? 'assets/logos/instagram.png'
                                        : contact.contact.toLowerCase() == 'facebook'
                                        ? 'assets/logos/facebook.png'
                                        : contact.contact.toLowerCase() == 'kakaotalk' || contact.contact.toLowerCase() == 'kakao'
                                        ? 'assets/logos/kakao.png'
                                        : contact.contact.toLowerCase() == 'line'
                                        ? 'assets/logos/LINE.png'
                                        : contact.contact.toLowerCase() == 'wechat'
                                        ? 'assets/logos/wechat.png'
                                        : contact.contact.toLowerCase() == 'whatsapp'
                                        ? 'assets/logos/whatsapp.png'
                                        : contact.contact.toLowerCase() == 'phone'
                                        ? 'assets/logos/phone.png'
                                        : 'assets/logos/phone.png',
                                  ),
                                  size: 20,

                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        contact.id,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  )
                                )
                              )
                              ],
                          ),
                          SizedBox(height: 8.0),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:
                                  Text(
                                    contact.location,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                              )
                            )
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child:
                                  Text(
                                    contact.character,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                              )
                            )
                          )
                        ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: Image.asset(
          'assets/icons/plus.png',
          height: 50.0,
          width: 50.0,
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
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
