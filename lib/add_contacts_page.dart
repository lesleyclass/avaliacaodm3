import 'package:flutter/material.dart';

import 'contact.dart';
import 'database_helper.dart';

class AddContactsPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  const AddContactsPage({required this.databaseHelper});

  @override
  _AddContactsPageState createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Contato'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:
          const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addContact();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addContact() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Contact newContact = Contact(
        id: "",
        name: _nameController.text.toString(),
        phone: _phoneController.text.toString(),
        email: _emailController.text.toString(),
      );

      await widget.databaseHelper.addContact(newContact);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato adicionado com sucesso!'),
        ),
      );

      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
    }
  }
}