import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/user_model.dart';

import '../../../colors.dart';
import '../widgets/chat_list.dart';
import '../widgets/bottom_chat_field.dart';


class MobileChatScreen extends ConsumerWidget {
  MobileChatScreen({Key? key, this.isTyping, required this.data}) : super(key: key);

  static const String routeName = '/mobile-chat-screen';
  final Map<String,dynamic> data;
  bool? isTyping = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(data['uid']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              {
                return Text(
                  data['name']
                );
              }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name']
                ),
                Text(
                      snapshot.data!.isOnline ? snapshot.data!.isTyping ? 'typing' : 'online' : 'offline',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                    ),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              print(data['uid']);
            },
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
           Expanded(
            child: ChatList(
              receiverUserId: data['uid']
            ),
          ),
          BottomChatField(receiverUserId: data['uid']),
        ],
      ),
    );
  }
}
