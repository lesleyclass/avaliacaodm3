import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'add_contacts_page.dart';
import 'contact.dart';
import 'database_helper.dart';
import 'details_contact_page.dart';
import 'edit_contact_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListContactsPage(),
    );
  }
}

class ListContactsPage extends StatefulWidget {
  const ListContactsPage({super.key});

  @override
  _ListContactsPageState createState() => _ListContactsPageState();
}

class _ListContactsPageState extends State<ListContactsPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper.database.onChildAdded.listen((event) {
      setState(() {
        final contact = _databaseHelper.formatContact(event.snapshot);
        _contacts.add(contact);
      });
    });
    _databaseHelper.database.onChildChanged.listen((event) {
      setState(() {
        final contact = _databaseHelper.formatContact(event.snapshot);
        int index = _contacts.indexWhere((updatedContact) => updatedContact.id == contact.id);
        _contacts[index] = contact;
      });
    });
    _databaseHelper.database.onChildRemoved.listen((event) {
      setState(() {
        final contact = _databaseHelper.formatContact(event.snapshot);
        int index = _contacts.indexWhere((removedContact) => removedContact.id == contact.id);
        _contacts.removeAt(index);
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meus Contatos')),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_contacts[index].name.toString()),
            subtitle: Text(_contacts[index].phone.toString()),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsContactPage(
                  contact: _contacts[index],
                  databaseHelper: _databaseHelper,
                )),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditContactPage(
                        contact: _contacts[index],
                        databaseHelper: _databaseHelper,
                      )),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar exclusão'),
                          content: Text('Tem certeza que deseja excluir este contato?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _deleteContact(_contacts[index]);
                              },
                              child: Text('Excluir'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactsPage(
              databaseHelper: _databaseHelper,
            )),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteContact(Contact contact) async {
    bool deleteContact = await _databaseHelper.deleteContact(contact.id.toString());

    String message = deleteContact ? "Contato deletado com sucesso!" : "Erro ao deletar contato";
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text(message),
      ),
    );
  }
}
