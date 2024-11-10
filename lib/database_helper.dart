import 'package:firebase_database/firebase_database.dart';

import 'contact.dart';
import 'firebase_options.dart';

class DatabaseHelper {
  static const String _dataBaseName = "contacts";
  final DatabaseReference database = FirebaseDatabase.instance.ref(_dataBaseName);

  Future<void> addContact(Contact contact) async {
    final newContactId = database.push().key.toString();
    contact.id = newContactId;
    database.child(newContactId).set(contact.toJson());
  }

  Future<Contact?> getContactById(String userId) async {
    var snapshot = await database.child("$_dataBaseName/$userId").get();
    if (snapshot.value != null) {
      return formatContact(snapshot);
    } else {
      return null;
    }
  }

  Contact formatContact(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    final Iterable<(String, dynamic)> iterableContacts = data.entries.map((entry) {
      return (entry.key.toString(), entry.value as dynamic);
    });
    final Map<String, dynamic> contact = {
      for (var entry in iterableContacts) entry.$1: entry.$2
    };
    return Contact.fromJson(contact, snapshot.key.toString());
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      await database.child(contact.id.toString()).update(contact.toJson());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteContact(String userId) async {
    try {
      await database.child(userId).remove();
      return true;
    } catch (error) {
      return false;
    }
  }
}