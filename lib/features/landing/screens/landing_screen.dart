import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';

import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.07,
                ),
                const Center(
                  child: Text(
                    'Welcome to WhatsU',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 9,
                ),
                Stack(
                  children: [
                    Image.asset(
                      'assets/bg.png',
                      fit: BoxFit.cover,
                      width: 340,
                      height: 340,
                      color: tabColor,
                    ),
                    Positioned(
                      top: 80,
                      bottom: 80,
                      left: 132,
                      child: Center(
                        child: Text(
                          'U',
                          style: TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height / 9,
                ),
                const Text(
                  'Read Our Privacy Policy. Tap "Agree and Continue" to accept the Terms of Service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: size.width * 0.75,
                  child: CustomButton(
                    text: 'AGREE AND CONTINUE',
                    onPressed: () => navigateToLoginScreen(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
