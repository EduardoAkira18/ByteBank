
// ignore_for_file: prefer_const_constructors

import 'package:bytebank/models/contact.dart';
import 'package:flutter/material.dart';

import 'contact_form.dart';

class ContactsList extends StatelessWidget {
  ContactsList({key}) : super(key: key);

  final List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    contacts.add(Contact(0, 'Akira', 1000));
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemBuilder: (context, index){
          final Contact
          contact = contacts[index];
          return _ContactItem(contact);
        },
        itemCount: contacts.length,
        // ignore: prefer_const_literals_to_create_immutables        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            )
          ).then((newContact) => debugPrint(newContact.toString()));
        },
        child: Icon(Icons.add),
      )
    );
  }
}

class _ContactItem extends StatelessWidget {

  final Contact contact;
  const _ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        )
      ),
    );
  }
}