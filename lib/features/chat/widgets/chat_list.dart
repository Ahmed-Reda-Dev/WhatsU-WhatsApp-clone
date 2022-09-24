import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/features/chat/widgets/sender_message_card.dart';

import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;

  const ChatList({required this.receiverUserId, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xFF128C7E),
            ));
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) {
                messageController.jumpTo(
                  messageController.position.maxScrollExtent,
                );
              },
            );
            return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                var timeSent = DateFormat('h:mm a').format(messageData.timeSent);
                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: timeSent,
                    type: messageData.type,
                  );
                }
                return SenderMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                );
              },
            );
          }
        });
  }
}
