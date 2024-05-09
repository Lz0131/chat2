import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:chatlinxs/managers/firestore_manager.dart';

class ContactProvider extends ChangeNotifier {
  bool isSearch = false;
  bool isLoadingFinished = false;
  TextEditingController controller = TextEditingController();
  List<Contact> selectedContacts = [];
  List<Contact> initialContacts = [];
  List<Contact> contacts = [];
  FirestoreManager manager = FirestoreManager();

  bool isContactSelected(Contact contact) => selectedContacts
      .any((contact) => contact.phones.contains(contact.phones.first.number));

  Future<List<Contact>?> getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true, withThumbnail: true);
      print("_contacts: $contacts");
      initialContacts = contacts;
      contacts = contacts;
      isLoadingFinished = true;
      notifyListeners();
    } else {
      print("Permission declined");
    }
    return null;
  }

  void toggleSearch() {
    isSearch = !isSearch;
    if (!isSearch) {
      contacts = initialContacts;
    }
    notifyListeners();
  }

  void onContactSearch(String value) {
    contacts = initialContacts
        .where((element) => element.displayName
        .toLowerCase()
        .contains(value))
        .toList();
    notifyListeners();
  }
}