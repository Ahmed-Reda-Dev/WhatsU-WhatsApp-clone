import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';

import '../../../models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.ref, required this.authRepository});

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUser();
    return user;
  }

  void signInWithPhoneNumber(String phoneNumber, context) {
    authRepository.signInWithPhoneNumber(phoneNumber, context);
  }

  void verifyOTP(
      {required String verificationId, required String userOTP, context}) {
    authRepository.verifyOtp(
      verificationId: verificationId,
      userOTP: userOTP,
      context: context,
    );
  }

  void saveUserInformation(context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Stream <UserModel> userDataById (String userId){
    return authRepository.userData(userId);
  }

  void setUserState (bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}