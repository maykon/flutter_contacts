import 'dart:io';
import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({Key key, this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();

  Contact _editedContact;
  bool _userEdited;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  void _changeName(String name) {
    _userEdited = true;
    setState(() {
      _editedContact.name = name;
    });
  }

  void _changeEmail(String email) {
    _userEdited = true;
    _editedContact.email = email;
  }

  void _changePhone(String phone) {
    _userEdited = true;
    _editedContact.phone = phone;
  }

  void _saveContact() {
    if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
      Navigator.pop(context, _editedContact);
    } else {
      FocusScope.of(context).requestFocus(_nameFocus);
    }
  }

  Future<bool> _requestPop() async {
    if (_userEdited != null && _userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<dynamic> contactImg = _editedContact.img != null
        ? FileImage(File(_editedContact.img))
        : AssetImage("images/person.png");

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo contato"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
              onPressed: () {
                ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                  if (file == null) return;
                  setState(() {
                    _editedContact.img = file.path;
                  });
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveContact,
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: contactImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.gallery)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: _changeName,
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              TextField(
                decoration: InputDecoration(labelText: "E-mail"),
                onChanged: _changeEmail,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: _changePhone,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
            ],
          ),
        ),
      ),
      onWillPop: _requestPop,
    );
  }
}
