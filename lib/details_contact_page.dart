import 'package:flutter/material.dart';

import 'contact.dart';
import 'database_helper.dart';
import 'edit_contact_page.dart';

class DetailsContactPage extends StatefulWidget {
  final Contact contact;
  final DatabaseHelper databaseHelper;
  DetailsContactPage({super.key, required this.contact, required this.databaseHelper});

  @override
  _DetailsContactPageState createState() => _DetailsContactPageState();
}

class _DetailsContactPageState extends State<DetailsContactPage> {
  Future<void> _deleteContact() async {
    bool deleteContact = await widget.databaseHelper.deleteContact(widget.contact.id.toString());

    String message = deleteContact ? "Contato deletado com sucesso!" : "Erro ao deletar contato";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name.toString()),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditContactPage(
                  contact: widget.contact,
                  databaseHelper: widget.databaseHelper,
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
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteContact;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${widget.contact.name}'),
            Text('Telefone: ${widget.contact.phone}'),
            Text('Email: ${widget.contact.email}'),
          ],
        ),
      ),
    );
  }
}