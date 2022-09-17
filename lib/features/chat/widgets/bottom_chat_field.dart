import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  BottomChatField({Key? key, required this.receiverUserId, bool? isTyping})
      : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isTyping = false;
  final TextEditingController _messageController = TextEditingController();
  Contact contactName = Contact();


  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
            contactName.displayName,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    isShowSendButton = true;
                    isTyping = true;
                  });
                } else {
                  setState(() {
                    isShowSendButton = false;
                    isTyping = false;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                    splashRadius: 23,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: SizedBox(
                    width: !isShowSendButton ? 100 : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        !isShowSendButton
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                                splashRadius: 20,
                              )
                            : InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.attach_file,
                                  color: Colors.grey,
                                ),
                              ),
                        !isShowSendButton
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                ),
                                splashRadius: 20,
                              )
                            : Container(
                                width: 1,
                              ),
                      ],
                    ),
                  ),
                ),
                hintText: 'Message',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: tabColor,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: sendTextMessage,
            child: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 24,
              child: isShowSendButton
                  ? const Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.mic_none_rounded,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
