import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';

import '../../../colors.dart';
import '../screens/mobile_chat_screen.dart';


class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Color(0xFF128C7E),));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var chatContactsData = snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MobileChatScreen.routeName,
                        arguments: {
                          'name' : chatContactsData.name,
                          'uid' : chatContactsData.contactId,
                        }
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          chatContactsData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatContactsData.lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            chatContactsData.profilePic,
                          ),
                          radius: 30,
                        ),
                        trailing: Text(
                          DateFormat('h:mm a').format(chatContactsData.timeSent),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: dividerColor, indent: 85),
                ],
              );
            },
          );
        }
      ),
    );
  }
}
