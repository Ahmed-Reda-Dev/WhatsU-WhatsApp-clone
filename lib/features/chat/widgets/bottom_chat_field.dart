import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField(
      {Key? key, required this.receiverUserId, bool? isTyping})
      : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isTyping = false;
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecoding = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecoding) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
        Fluttertoast.showToast(
            msg: "Sending...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: tabColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
        Fluttertoast.showToast(
            msg: "Recording...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: tabColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      setState(() {
        isRecoding = !isRecoding;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(
        image,
        MessageEnum.image,
      );
      Fluttertoast.showToast(
          msg: "Sending...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: tabColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(
        video,
        MessageEnum.video,
      );
      Fluttertoast.showToast(
          msg: "Sending...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: tabColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  // void selectGIF() async {
  //   final gif = await pickGIF(context);
  //   if (gif != null) {
  //     ref.read(chatControllerProvider).sendGIFMessage(
  //           context,
  //           gif.url,
  //           widget.receiverUserId,
  //         );
  //   }
  // }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  onTap: () {
                    setState(() {
                      isShowEmojiContainer = false;
                    });
                  },
                  controller: _messageController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                        isTyping = true;
                      });
                    } else if (value.isEmpty || value == '') {
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
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                        splashRadius: 23,
                      ),
                      // isShowSendButton
                      //     ? IconButton(
                      //         onPressed: toggleEmojiKeyboardContainer,
                      //         icon: const Icon(
                      //           Icons.emoji_emotions_outlined,
                      //           color: Colors.grey,
                      //         ),
                      //         splashRadius: 23,
                      //       )
                      //     : Row(
                      //         children: [
                      //           IconButton(
                      //             onPressed: toggleEmojiKeyboardContainer,
                      //             icon: const Icon(
                      //               Icons.emoji_emotions_outlined,
                      //               color: Colors.grey,
                      //             ),
                      //             splashRadius: 23,
                      //           ),
                      //           IconButton(
                      //             onPressed: (){},
                      //             icon: const Icon(
                      //               Icons.gif_box_outlined,
                      //               color: Colors.grey,
                      //             ),
                      //             splashRadius: 23,
                      //           ),
                      //         ],
                      //       ),
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
                                    onPressed: selectVideo,
                                    icon: const Icon(
                                      Icons.attach_file,
                                      color: Colors.grey,
                                    ),
                                    splashRadius: 20,
                                  )
                                : InkWell(
                                    onTap: selectVideo,
                                    child: const Icon(
                                      Icons.attach_file,
                                      color: Colors.grey,
                                    ),
                                  ),
                            !isShowSendButton
                                ? IconButton(
                                    onPressed: selectImage,
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
                      : isRecoding
                          ? const Icon(
                              Icons.stop_circle_outlined,
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
          isShowEmojiContainer
              ? SizedBox(
                  height: 310,
                  child: EmojiPicker(
                    onEmojiSelected: ((category, emoji) {
                      setState(() {
                        _messageController.text =
                            _messageController.text + emoji.emoji;
                      });
                      setState(() {
                        isShowSendButton = true;
                      });
                    }),
                    onBackspacePressed: () {
                      _messageController.text = _messageController
                          .text.characters
                          .skipLast(1)
                          .toString();
                    },
                    config: Config(
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: mobileChatBoxColor,
                      indicatorColor: tabColor,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.white,
                      progressIndicatorColor: tabColor,
                      backspaceColor: tabColor,
                      skinToneDialogBgColor: mobileChatBoxColor,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      noRecents: const Text(
                        'No Resents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
