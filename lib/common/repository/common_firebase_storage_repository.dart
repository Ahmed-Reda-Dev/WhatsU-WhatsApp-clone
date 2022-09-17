import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRepository(fireStorage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseStorageRepository {
final FirebaseStorage fireStorage;
  CommonFirebaseStorageRepository({required this.fireStorage});

  Future<String> storeFileToFirebase(String ref, File file) async
  {
    UploadTask uploadTask = fireStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}