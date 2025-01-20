import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key? key,
  }) : super(key: key);

  String getHijryMonthName(int month) {
    String monthName = "";
    if (month == 1) {
      monthName = "المحرم";
    }
    if (month == 2) {
      monthName = "صفر";
    }
    if (month == 3) {
      monthName = "ربيع الأول";
    }
    if (month == 4) {
      monthName = "ربيع الآخر";
    }
    if (month == 5) {
      monthName = "جمادى الأولى";
    }
    if (month == 6) {
      monthName = "جمادى الآخرة";
    }
    if (month == 7) {
      monthName = "رجب";
    }
    if (month == 8) {
      monthName = "شعبان";
    }
    if (month == 9) {
      monthName = "رمضان";
    }
    if (month == 10) {
      monthName = "شوال";
    }
    if (month == 11) {
      monthName = "ذو القعدة";
    }
    if (month == 12) {
      monthName = "ذو الحجة";
    }
    return monthName;
  }

  String getHijryDayName(String day) {
    String dayName = "";
    if (day == "Sunday") {
      dayName = "الأحد";
    }
    if (day == "Saturday") {
      dayName = "السبت";
    }
    if (day == "Monday") {
      dayName = "الاثنين ";
    }
    if (day == "Wednesday") {
      dayName = "الأربعاء";
    }
    if (day == "Tuesday") {
      dayName = "الثلاثاء";
    }
    if (day == "Thursday") {
      dayName = "الخميس";
    }
    if (day == "Friday") {
      dayName = "الجمعة";
    }
    return dayName;
  }

  @override
  Widget build(BuildContext context) {
    var today = HijriCalendar.now();
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, bottom: 25),
      child: Column(
        children: [
          Text(
            getHijryDayName(today.dayWeName.toArabicNumbers),
            style: GoogleFonts.noticiaText(
              textStyle: TextStyle(
                fontSize: 27.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff592c01),
              ),
            ),
          ),
          Text(
            "${DateTime.now().year.toArabicNumbers}/${DateTime.now().month.toArabicNumbers}/${DateTime.now().day.toArabicNumbers}",
            style: GoogleFonts.noticiaText(
              textStyle: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff592c01),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${today.hYear.toArabicNumbers}/",
                style: GoogleFonts.noticiaText(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff592c01),
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),
              Text(
                "${getHijryMonthName(today.hMonth).toArabicNumbers}/",
                style: GoogleFonts.noticiaText(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff592c01),
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),
              Text(
                today.hDay.toArabicNumbers,
                style: GoogleFonts.noticiaText(
                  textStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff592c01),
                      textBaseline: TextBaseline.alphabetic),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
