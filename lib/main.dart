// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vanilla Contacts Demo',
      home: HomePage(),
      routes: {
        '/new-contact': (context) => NewContactView(),
      },
    );
  }
}

class Contact {
  final String id;
  final String name;
  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  void add({required Contact contact}) {
    // value.add(contact);
    // notifyListeners();

    final contacts = value;
    contacts.add(contact);
    // value = contacts;
    notifyListeners();

    // value.add(contact);
    // notifyListeners();
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final array1 = ["foo", "bar"];
    // final array2 = array1;
    // array2.add("baz");
    // if (array1 == array2) {
    //   print("they are equal");
    // } else {
    //   print("they are not equal");
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Home Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction) {
                  ContactBook().remove(contact: contact);
                },
                key: ValueKey(contact.id),
                child: Material(
                  color: Colors.white,
                  elevation: 6.0,
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () async {
          Navigator.of(context).pushNamed('/new-contact');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Add a new contact",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: "Enter a new contact name here..."),
            ),
            TextButton(
              onPressed: () {
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.pop(context);
              },
              child: Text(
                "Add Contact",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
