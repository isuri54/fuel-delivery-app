import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/consts.dart';
import 'package:flutter_application_6/res/custombtn.dart';
import 'package:flutter_application_6/res/customtf.dart';
import 'package:flutter_application_6/views/home_view/homeview.dart';
import 'package:flutter_application_6/views/signup_view/signupview.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundLayout(),
    );
  }
}


class BackgroundLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.bgimg), // Path to your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Positioned buttons
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppStyles.normal(title: "Login", size: AppSizes.size34, color: Colors.white),
              20.heightBox,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Adjust the width
                child: CustomTextField(
                  hint: "EMAIL",
                  textController: TextEditingController(),
                  textColor: Colors.black54,
                  borderColor: Colors.transparent,
                  inputColor: AppColors.textC,
                  icon: Icons.email,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Adjust the width
                child: CustomTextField(
                  hint: "PASSWORD",
                  textController: TextEditingController(),
                  textColor: Colors.black54,
                  borderColor: Colors.transparent,
                  inputColor: AppColors.textC,
                  icon: Icons.lock,
                ),
              ),
              30.heightBox,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: CustomButton(
                  buttonText: "LOGIN", 
                  onTap: () {
                    Get.offAll(() => const HomeView());
                  },
                  textColor: Colors.black,
                  buttonColor: AppColors.greenC,
                ),
              ),
              20.heightBox,
              GestureDetector(
                onTap: () {
                  Get.to(() => const Signupview());
                },
                child: Container(
                  child: AppStyles.normal(title: "Do not have an account?  SIGN UP", size: AppSizes.size18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}