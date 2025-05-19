import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/fonts.dart';
import 'package:flutter_application_6/res/waitingscreen.dart';
import 'package:flutter_application_6/views/signup_view/signupview.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: AppFonts.kanitBlack
      ),
      debugShowCheckedModeBanner: false,
      home: const WaitingScreen(),
    );
  }
}


