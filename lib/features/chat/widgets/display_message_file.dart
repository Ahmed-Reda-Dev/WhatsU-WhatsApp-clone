import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_palyer_Item.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class DisplayMessageFile extends StatelessWidget {
  final MessageEnum type;
  final String message;
  const DisplayMessageFile({
    Key? key,
    required this.type,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(
                builder: (context, setState) => IconButton(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.stop : Icons.play_circle_fill_outlined,
                  ),
                ),
              )
            : type == MessageEnum.video
                ? ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(5),
                    child: VideoPlayerItem(
                      videoUlr: message,
                    ),
                  )
                : type == MessageEnum.gif
                    ? ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: message,
                        ),
                      )
                    : ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: message,
                        ),
                      );
  }
}
