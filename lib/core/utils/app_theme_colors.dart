import 'package:flutter/material.dart';

class AppColors {
  static const Color kPrimaryColor = Color(0xff113644);
  static const Color kScafoldBgColor = Color.fromRGBO(0, 0, 0, 1);
  static const Color kTextColor1 = Colors.black;
  static const Color kTextColor2 = Color(0xff595959);
  static const Color kRedColor = Color(0xffD91E1C);
  static const Color kGreyColor = Color(0xffECECEC);
  static const Color kBuleColor = Color(0xff00AEEF);
  static const Color kwhite = Color.fromARGB(255, 255, 255, 255);
  static const Color kTealColor = Colors.teal;
  static const Color kWhiteColor = Colors.white;
  static const Color BGreyIconColor = Color(0xffC4C2C5);
  static const Color BBGwColor = Color(0xffF9F6F9);
  static const Color BGreyTextColor = Color(0xffABA8AB);

  /// scaffold background colors
  static Color lightGrey = Colors.grey.shade100;
  static const Color black = Colors.black;
  static Color greyLight = Colors.grey[400]!;
  static Color whiteWithOpacity = const Color.fromRGBO(255, 255, 255, 230);

  ///////////////////////////
  static Color DefaultColor = const Color(0xffE95C1F);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
class MyColors {
  static const Color darkBrown = Color(0xff592B00);
  static const Color babyBrown = Color(0xffA85000);
  static const Color lightBrown = Color(0xffFFE9CE);
  static const Color creamColor = Color(0xffFAF6EB);
  static const Color appBackGroundColor = Color(0xffFAF6EB);
  static const Color whiteColor = Colors.white;

  static const Color primaryColor = Color(0xff9B7EF8);
  static const Color orange = Color(0xffEF9A53);
  static const Color babyOrange = Color(0xffF5D5AE);
  static const Color darkBlue = Color(0xff1D2356);
}