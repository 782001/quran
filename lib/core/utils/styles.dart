import 'package:flutter/material.dart';

import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/strings.dart';

abstract class TextStyles {
  static const TextStyle stylewhitebold25 = TextStyle(
    color: Colors.white,
    fontSize: 25,
    fontFamily: cairoFont,
    fontWeight: FontWeight.bold,
  );
  static TextStyle styleblueShade900bold18 = TextStyle(
      fontFamily: cairoFont,
      color: Colors.blue.shade900,
      // fontSize: context.height * 0.017,
      fontSize: 18,
      fontWeight: FontWeight.bold);
  static TextStyle styleellipsisblueShade900bold18 = TextStyle(
      fontFamily: cairoFont,
      color: Colors.blue.shade900,
      // fontSize: context.height * 0.017,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis);
  static TextStyle styleellipsisblueShade900bold22 = TextStyle(
      fontFamily: cairoFont,
      color: Colors.blue.shade900,
      // fontSize: context.height * 0.017,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis);
  static const TextStyle styleblack25 = TextStyle(
    color: Colors.black,
    fontSize: 25,
    fontFamily: cairoFont,
  );
  static const TextStyle styleblackbold25 = TextStyle(
      color: Colors.black,
      fontSize: 25,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static const TextStyle styleWhiteBold15 = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static TextStyle stylegreyBold15 = TextStyle(
      color: Colors.grey.shade700,
      fontSize: 15,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static const TextStyle styleblackBold15 = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static const TextStyle styleblack15 = TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: cairoFont,
  );
  static const TextStyle styleblackBold17 = TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static const TextStyle styleblue15 = TextStyle(
    color: Colors.blue,
    fontSize: 15,
    fontFamily: cairoFont,
  );
  static const TextStyle style12 = TextStyle(
    fontSize: 15,
    fontFamily: cairoFont,
  );
  // static const TextStyle stylekTextLightColor15 = TextStyle(
  //   color: AppColors.kTextLightColor,
  //   fontSize: 15,
  //   fontFamily: cairoFont,
  // );
  static const TextStyle styleteal = TextStyle(
      color: Colors.teal, fontFamily: cairoFont, fontWeight: FontWeight.bold);
  static const TextStyle styletealbold25 = TextStyle(
    fontFamily: cairoFont,
    color: Colors.teal,
    fontSize: 25,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle styleWhite18 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: cairoFont,
  );
  static const TextStyle styleWhite40 = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontFamily: cairoFont,
  );
  static const TextStyle styleblackBold18 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: cairoFont,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle styleblackBold16 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: cairoFont,
    // fontWeight: FontWeight.bold,
  );
  static const TextStyle stylewhiteBold18 = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: cairoFont,
    fontWeight: FontWeight.bold,
    // height: 0,
  );
  static const TextStyle styleellipsiswhiteBold18 = TextStyle(
    color: Colors.white, overflow: TextOverflow.ellipsis,
    fontSize: 18,
    fontFamily: cairoFont,
    fontWeight: FontWeight.bold,
    // height: 0,
  );
  static const TextStyle style24 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontFamily: cairoFont,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static const TextStyle styleblackbold20 = TextStyle(
      fontFamily: cairoFont,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20);
  static const TextStyle stylewhitebold20 = TextStyle(
      fontFamily: cairoFont,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20);
  static const TextStyle stylewhite20 =
      TextStyle(fontFamily: cairoFont, color: Colors.white, fontSize: 20);
  static const TextStyle styleblack20 =
      TextStyle(fontFamily: cairoFont, color: Colors.black, fontSize: 20);

  static const TextStyle stylewhite22 = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontFamily: cairoFont,
  );
  static const TextStyle stylebold22 = TextStyle(
    fontSize: 22,
    fontFamily: cairoFont,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle stylewhitebold35 = TextStyle(
    fontSize: 35,
    color: Colors.white,
    fontFamily: cairoFont,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle stylewhite35 = TextStyle(
    fontSize: 35,
    color: Colors.white,
    fontFamily: cairoFont,
  );
  static const TextStyle styleellipsisbold13 = TextStyle(
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold,
      fontSize: 13,
      overflow: TextOverflow.ellipsis);
  static const TextStyle styleellipsis18 = TextStyle(
    fontFamily: cairoFont,
    fontSize: 18,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle styleeredllipsis18 = TextStyle(
      fontFamily: cairoFont,
      fontSize: 20,
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      color: Colors.blue);
  static const TextStyle styleellipsisbold20 = TextStyle(
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      overflow: TextOverflow.ellipsis);
  static const TextStyle styleellipsisbold18 = TextStyle(
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      overflow: TextOverflow.ellipsis);
  static const TextStyle styleellipsisbold15 = TextStyle(
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      overflow: TextOverflow.ellipsis);
  static TextStyle stylebluebold30 = TextStyle(
      color: Colors.blue.shade900,
      fontSize: 30,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static const TextStyle stylewhitebold30 = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontFamily: cairoFont,
      fontWeight: FontWeight.bold);

  static const TextStyle stylebold29 = TextStyle(
      fontSize: 29, fontFamily: cairoFont, fontWeight: FontWeight.bold);

  static const TextStyle styleblack19 = TextStyle(
    color: Colors.black,
    fontSize: 19,
    fontFamily: cairoFont,
  );

  static const TextStyle styleblackDefault =
      TextStyle(fontFamily: cairoFont, color: Colors.black);

  static const TextStyle stylewhiteboldDefault = TextStyle(
      fontFamily: cairoFont, color: Colors.white, fontWeight: FontWeight.bold);
  static const TextStyle stylewhiteDefault = TextStyle(
    fontFamily: cairoFont,
    color: Colors.white,
  );
}
