// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final String recieverName;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(
    this.message,
    this.recieverName,
    this.isMe,
    this.messageEnum,
  );
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
