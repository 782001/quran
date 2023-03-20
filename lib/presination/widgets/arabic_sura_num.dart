import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';

class ArabicSuraNumber extends StatelessWidget {
  const ArabicSuraNumber({Key? key, required this.i}) : super(key: key);
  final int i;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      "\uFD3E" + (i + 1).toString().toArabicNumbers + "\uFD3F",
      style: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: me_quranFont,
          fontSize: arabicFontSize,
          shadows: const [
            Shadow(
              offset: Offset(.5, .5),
              blurRadius: 1.0,
              color: Colors.amberAccent,
            ),
          ]),
    );
  }
}
