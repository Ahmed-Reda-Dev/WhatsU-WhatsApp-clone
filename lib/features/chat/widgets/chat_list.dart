import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/widgets/sender_message_card.dart';

import '../../../info.dart';
import '../../../widgets/my_message_card.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId;
  const ChatList({required this.receiverUserId,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Message>>(
      stream: ref.watch(chatControllerProvider).chatStream(receiverUserId),
      builder: (context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF128C7E),));
          } else {
          return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            if (messages[index]['isMe'] == true) {
              return MyMessageCard(
                message: messageData.text,
                date: messages[index]['time'].toString(),
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: messages[index]['time'].toString(),
            );
          },
        );
        }
      }
    );
  }
}
