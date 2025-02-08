import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';


class AppFonts {
  static String kanitBlack = "Kanit-Black";
}

class AppSizes {
  static const size12 = 12.0, size14 = 14.0, size16 = 16.0, size18= 18.0, size20 = 20.0, size22 = 22.0, size34 = 34.0;
}

class AppStyles {
  static  normal({required String title, Color? color = Colors.black, double? size = 14, TextAlign alignment = TextAlign.left}) {
    return title.text.size(size).color(color).make();
  }
}