import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/chat/widgets/display_message_file.dart';

import '../../../colors.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: 350.0,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width - 270,
        maxWidth: MediaQuery.of(context).size.width - 45,
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: mobileChatBoxColor,
          borderRadius: BorderRadius.circular(8),
        ),
        // constraints: BoxConstraints(
        //   minWidth: MediaQuery.of(context).size.width - 270,
        //   maxWidth: MediaQuery.of(context).size.width - 45,
        // ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(
                messageReply!.isMe == true ? 'You' : messageReply.recieverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => cancelReply(ref),
              child: const Icon(
                Icons.close,
                size: 18,
              ),
            ),
          ]),
          const SizedBox(
            height: 8,
          ),
          DisplayMessageFile(
            message: messageReply.message,
            type: messageReply.messageEnum,
          ),
        ]),
      ),
    );
  }
}
