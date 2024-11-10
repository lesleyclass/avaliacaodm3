import 'package:flutter/material.dart';

import 'contact.dart';
import 'database_helper.dart';

class EditContactPage extends StatefulWidget {
  final Contact contact;
  final DatabaseHelper databaseHelper;

  EditContactPage({required this.contact, required this.databaseHelper});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.name.toString();
    _phoneController.text = widget.contact.phone.toString();
    _emailController.text = widget.contact.email.toString();
  }

  Future<void> _editContact() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Contact newContact = Contact(
        id:  widget.contact.id.toString(),
        name: _nameController.text.toString(),
        phone: _phoneController.text.toString(),
        email: _emailController.text.toString(),
      );

      bool editContact = await widget.databaseHelper.updateContact(newContact);

      String message = editContact ? "Contato editado com sucesso!" : "Erro ao editar o contato";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Contato')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!= null && value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value!= null && value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!= null && value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editContact,
        child: const Icon(Icons.save),
      ),
    );
  }
}