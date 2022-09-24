import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
const String defaultImage = 'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1608/tuktukdesign160800043/61010830-user-icon-man-profile-businessman-avatar-person-glyph-vector-illustration.jpg?ver=6';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      image = File(pickedImage.path);
    }
  }catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try{
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  }catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

// Future<GiphyGif?> pickGIF (BuildContext context) async {
//   GiphyGif? gif;
//   String apiKey = 'OSlXJD5fgJzgRG1q06sM0ThF48oC1HWm';
//   try{
//     gif = await Giphy.getGif(context: context, apiKey: apiKey);
//   }catch (e){
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }

