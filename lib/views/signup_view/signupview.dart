import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/consts.dart';
import 'package:flutter_application_6/res/custombtn.dart';
import 'package:flutter_application_6/res/customtf.dart';
import 'package:flutter_application_6/views/login_view/loginview.dart';
import 'package:get/get.dart';

class Signupview extends StatefulWidget {
  const Signupview({super.key});

  @override
  State<Signupview> createState() => _SignupviewState();
}

class _SignupviewState extends State<Signupview> {
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
              AppStyles.normal(title: "Sign Up", size: AppSizes.size34, color: Colors.white),
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
              20.heightBox,
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
              20.heightBox,
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Adjust the width
                child: CustomTextField(
                  hint: "CONFIRM PASSWORD",
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
                  buttonText: "SIGN UP", 
                  onTap: () {
                    Get.to(() => LoginView());
                  },
                  textColor: Colors.black,
                  buttonColor: AppColors.greenC,
                ),
              ),
              20.heightBox,
              GestureDetector(
                onTap: () {
                  Get.to(() => const LoginView());
                },
                child: Container(
                  child: AppStyles.normal(title: "Already have an account?  LOGIN", size: AppSizes.size18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}