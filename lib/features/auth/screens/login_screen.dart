import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import '../../../common/utils/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  Country? country;
  final phoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry()
  {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber()
  {
    String phoneNumber = phoneController.text.trim();
    if(phoneNumber.isNotEmpty && country != null)
    {
      ref.read(authControllerProvider).signInWithPhoneNumber('+${country!.phoneCode}$phoneNumber', context);
    }else if(phoneNumber.isEmpty){
      showSnackBar( context: context,content: 'Invalid phone number !',);
    }else if(country == null){
      showSnackBar( context: context,content: 'Please select country !',);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              const Text('What\'s U needs your phone number to verify your account.'),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: pickCountry,
                child: const Text(
                  'pick a country',
                  style: TextStyle(
                    color: tabColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  if(country != null)
                    Text(
                      '+${country!.phoneCode}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      decoration:  const InputDecoration(
                        hintText: 'phone number',
                      ),
                      cursorColor: tabColor,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                    ),
                  ),
                ],
              ),
               SizedBox(
                height: size.height * 0.6,
              ),
              SizedBox(
                width:90,
                child: CustomButton(
                  text: 'Next',
                  onPressed: sendPhoneNumber,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
