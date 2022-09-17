import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

import '../../../models/user_model.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(
    fireStore: FirebaseFirestore.instance,
  ),
);

class SelectContactsRepository {
  final FirebaseFirestore fireStore;

  SelectContactsRepository({required this.fireStore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, context) async{
    try{
      var userController = await fireStore.collection('users').get();
      bool isFound = false;
      for(var document in userController.docs)
        {
          var userData = UserModel.fromMap(document.data());
          String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(' ', '');
          if (selectedPhoneNum == userData.phoneNumber)
          {
            isFound = true;
            Navigator.pushNamed(context, MobileChatScreen.routeName,arguments: {
              'name' : selectedContact.displayName,
              'uid' : userData.uid,
            });
          }
        }
      if (!isFound){
        showSnackBar(context: context, content: 'This contact does not exist on WhatsU');
      }
    }catch(e){
    showSnackBar(context: context, content: 'This contact does not exist on WhatsU');
    }
  }
}

