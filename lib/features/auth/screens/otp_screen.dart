import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';
  final String verificationId;
  int otpLength = 0;

   OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(String userOTP, context, WidgetRef ref) {
    ref.read(authControllerProvider).verifyOTP(
      verificationId: verificationId,
      userOTP: userOTP,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'We have sent an SMS with a code.',
            ),
            SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.1,
              child: TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '__  __  __  __  __  __',
                ),
                onChanged: (String value) {
                  if (value.length == 6) {
                    verifyOTP(value, context, ref);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
