import 'package:contacts/helpers/contact_helper.dart';
import 'package:contacts/ui/contact_page.dart';
import 'package:flutter/material.dart';

import 'contact_tile.dart';

enum OrderOptions { orderAz, orderZa }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> _contacts = List();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  void dispose() {
    helper.close();
    super.dispose();
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(contact: contact),
      ),
    );
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        _contacts = list;
      });
    });
  }

  void _deleteContacts(Contact contact) async {
    await helper.deleteContact(contact.id);
    setState(() {
      _contacts.remove(contact);
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAz:
        _contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZa:
        _contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contatos"),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                    const PopupMenuItem<OrderOptions>(
                      child: Text("Ordenar de A-Z"),
                      value: OrderOptions.orderAz,
                    ),
                    const PopupMenuItem<OrderOptions>(
                      child: Text("Ordenar de Z-A"),
                      value: OrderOptions.orderZa,
                    ),
                  ],
              onSelected: _orderList,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return buildContactCard(
                context, _contacts[index], _showContactPage, _deleteContacts);
          },
          itemCount: _contacts.length,
        ));
  }
}
