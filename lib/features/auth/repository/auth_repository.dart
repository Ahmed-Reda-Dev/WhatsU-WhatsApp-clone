import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';

import '../screens/otp_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    fireStore: FirebaseFirestore.instance,
  ),
);


class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  AuthRepository({required this.auth, required this.fireStore});

  Future<UserModel?> getCurrentUser() async {
    var userData = await fireStore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhoneNumber(String phoneNumber, context) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(context: context, content: e.message!);
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void verifyOtp(
      {required String verificationId,
      required String userOTP,
      context}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uId = auth.currentUser!.uid;
      String photoUrl = defaultImage;

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profile/$uId',
              profilePic,
            );
      }
      var user = UserModel(
        uid: uId,
        name: name,
        profilePic: photoUrl,
        isOnline: true,
        isTyping: false,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );
      await fireStore.collection('users').doc(uId).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context,
          MaterialPageRoute(
            builder: (context) => MobileLayoutScreen(),
          ),
            (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream <UserModel> userData (String userId){
    return fireStore.collection('users').doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState (bool isOnline) async {
    await fireStore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline' : isOnline
    });
  }
}
