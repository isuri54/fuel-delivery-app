import 'package:flutter/material.dart';
import 'package:flutter_application_6/consts/fonts.dart';
import 'package:flutter_application_6/views/login_view/loginview.dart';
import 'package:get/get.dart';

import 'views/home_view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
      home: const LoginView(),
    );
  }
}


