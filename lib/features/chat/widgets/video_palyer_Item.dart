import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUlr;
  const VideoPlayerItem({Key? key, required this.videoUlr}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlay = false;


  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUlr)
      ..initialize().then(
        (value) => videoPlayerController.setVolume(1),
      );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   videoPlayerController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 10 / 16.5,
      child: Stack(
        children: [
          VisibilityDetector(
            key: const Key("unique key"),
            onVisibilityChanged: (VisibilityInfo info) {
              if(info.visibleFraction == 0){
                videoPlayerController.pause();
              }
            },
            child: CachedVideoPlayer(
              videoPlayerController,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if(isPlay) {
                  videoPlayerController.pause();
                }else {
                  videoPlayerController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              },
              icon: isPlay ? const Icon(Icons.pause_circle_outline): const Icon(
                Icons.play_circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
