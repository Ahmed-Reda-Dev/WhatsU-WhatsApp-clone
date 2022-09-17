import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_controller.dart';


class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select-contacts';
  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(BuildContext context, WidgetRef ref, Contact selectedContact){
    ref.watch(selectContactControllerProvider).selectedContact(
        selectedContact,
        context
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Select Contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactsList) => ListView.builder(
              itemBuilder: (context, index) {
                final contact = contactsList[index];
                return InkWell(
                  onTap: () => selectContact(context, ref, contact),
                  child: ListTile(
                    title: Text(contact.displayName),
                    leading: contact.photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30.0,
                          ),
                  ),
                );
              },
              itemCount: contactsList.length,
            ),
            error: (error, trac) => ErrorScreen(error: error.toString()),
            loading: () => const LinearProgressIndicator(color: Color(0xFF128C7E),),
          ),
    );
  }
}
