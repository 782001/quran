import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
    required this.prayName,
    required this.prayTime,
  });

  final String prayName;
  final String prayTime;
  @override
  Widget build(BuildContext context) {
    print(prayName);
    print("${prayTime.split(':').first} --- ${DateTime.now().hour}");
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        // CircleAvatar(
        //   radius: 47.5.sp,
        //   backgroundColor: MyColors.darkBrown,
        // ),

        CircleAvatar(
          radius: 42.8.sp,
          backgroundColor: const Color(0xffFAF6EB),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                prayName,
                textAlign: TextAlign.right,
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 18.sp,
                  color: MyColors.babyBrown,
                ),
              ),
              Text(
                prayTime.toArabicNumbers,
                textAlign: TextAlign.right,
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          child: CircularProgressIndicator(
            backgroundColor: MyColors.lightBrown,
            value: (DateTime.now().hour / int.parse(prayTime.split(':').first)),
            color: MyColors.darkBrown,
          ),
        ),
      ],
    );
  }
}
