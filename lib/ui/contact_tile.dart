import 'dart:io';
import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildContactCard(BuildContext context, Contact contact,
    Function showContactPage, Function deleteContacts) {
  ImageProvider<dynamic> contactImg = contact.img != null
      ? FileImage(File(contact.img))
      : AssetImage("images/person.png");
  var textStyle = TextStyle(fontSize: 18.0);

  return GestureDetector(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: contactImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contact.name ?? "",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contact.email ?? "",
                    style: textStyle,
                  ),
                  Text(
                    contact.phone ?? "",
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      //showContactPage(contact: contact);
      _showOptions(context, contact, showContactPage, deleteContacts);
    },
  );
}

void _showOptions(BuildContext context, Contact contact,
    Function showContactPage, Function deleteContacts) {
  var texStyle = TextStyle(color: Colors.red, fontSize: 20.0);

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Ligar",
                      style: texStyle,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      launch("tel:${contact.phone}");
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Editar",
                      style: texStyle,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showContactPage(contact: contact);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Apagar",
                      style: texStyle,
                    ),
                    onPressed: () {
                      deleteContacts(contact);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          onClosing: () {},
        );
      });
}
