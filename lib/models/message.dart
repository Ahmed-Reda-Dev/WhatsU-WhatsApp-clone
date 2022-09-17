import 'package:whatsapp_clone/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String messageId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final bool isSeen;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'text': text,
      'type': type.type,
      'timeSent': timeSent,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId : map['senderId'] ?? '',
      receiverId : map['receiverId'] ?? '',
      messageId : map['messageId'] ?? '',
      text : map['text'] ?? '',
      type : (map['type'] as String).toEnum(),
      timeSent : DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen : map['isSeen'] ?? false,
    );
  }
}
