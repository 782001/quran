import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/presination/pray_time_presentation/controller/pray_time_cubit.dart';

import '../constance/functions.dart';

class TimerCountWidget extends StatefulWidget {
  const TimerCountWidget({
    super.key,
    required this.cubit,
    required this.color,
  });

  @override
  State<TimerCountWidget> createState() => _TimerCountWidgetState();
  final PrayTimeCubit cubit;
  final Color color;
}

class _TimerCountWidgetState
    extends State<TimerCountWidget> /* with AutomaticKeepAliveClientMixin*/ {
  // @override
  // bool get wantKeepAlive => true;

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  late Timer _timer;

  void calculateTimeRemain() {
    // _hours = DateTime.now().hour - widget.cubit.timeForNextPray!.hour;
    // _minutes = DateTime.now().minute - widget.cubit.timeForNextPray!.minute;
    // _seconds = DateTime.now().second - widget.cubit.timeForNextPray!.second;
    //
    // print("_hours");
    // print(_hours);
    // print("_minutes");
    // print(_minutes);
    // print("_seconds");
    // print(_seconds);
    //
    // if (_hours < 0) _hours *= -1;
    // if (_minutes < 0) _minutes *= -1;
    // if (_seconds < 0) _seconds *= -1;

    // Define two times as strings (HH:MM:SS)
    String time1 = DateTime.now().toString();
    String time2 = widget.cubit.timeForNextPray!.toString();

    print("time1 $time1");
    print("time2 $time2");

    // Convert the time strings to DateTime objects
    DateTime dateTime1 = DateTime.parse(time1);
    DateTime dateTime2 = DateTime.parse(time2);
    print("dateTime1 $dateTime1");
    print("dateTime2 $dateTime2");

    // Calculate the difference between the two times
    Duration difference = dateTime2.difference(dateTime1);

    print("difference $difference");

    // Extract hours, minutes, and seconds from the duration
    _hours =
        (difference.inHours < 0 ? difference.inHours - 1 : difference.inHours) %
            24;
    print("_hours $_hours");
    _minutes = difference.inMinutes % 60;
    _seconds = difference.inSeconds % 60;
    // _hours = 0;
    // _minutes = 0;
    // _seconds = 5;

    // if (_hours < 0) _hours *= -1;
    // if (_minutes < 0) _minutes *= -1;
    // if (_seconds < 0) _seconds *= -1;

    print(
        "Time Difference: $_hours hours, $_minutes minutes, $_seconds seconds");
  }

  @override
  void initState() {
    super.initState();
    calculateTimeRemain();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      //print("widget.cubit.nextPray ==>");
      //print(widget.cubit.nextPray);
      setState(() {
        if (_hours == 0 && _minutes == 0 && _seconds == 0) {
          if (widget.cubit.nextPray == Prayer.fajr) {
            print("++++++++++++++++++++++++++++");
            // AppFunctions.sendNotification(
            //     title: '', body: 'حان الان موعد صلاة الفجر', type: "pray");
          } else if (widget.cubit.nextPray == Prayer.sunrise) {
            // AppFunctions.sendNotification(
            //     title: '', body: 'حان الان موعد صلاة الشروق', type: "pray");
          } else if (widget.cubit.nextPray == Prayer.dhuhr) {
            // AppFunctions.sendNotification(
            //     title: '', body: 'حان الان موعد صلاة الظهر', type: "pray");
          } else if (widget.cubit.nextPray == Prayer.asr) {
            // AppFunctions.sendNotification(
            //     title: '', body: 'حان الان موعد صلاة العصر', type: "pray");
          } else if (widget.cubit.nextPray == Prayer.maghrib) {
            // AppFunctions.sendNotification(
            //     title: '', body: 'حان الان موعد صلاة المغرب', type: "pray");
          } else if (widget.cubit.nextPray == Prayer.isha) {
            // AppFunctions.sendNotification(
            //     title: '', body: 'حان الان موعد صلاة العشاء', type: "pray");
          }
          _timer.cancel();
          // Timer has finished, you can perform an action here.
        } else if (_minutes == 0 && _seconds == 0) {
          _hours--;
          _minutes = 59;
          _seconds = 59;
        } else if (_seconds == 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _seconds--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 3.w,
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const SizedBox(
              width: 4,
            ),
            CircleAvatar(
              radius: 50.sp,
              backgroundColor: MyColors.darkBrown,
            ),
            CircleAvatar(
              radius: 43.sp,
              backgroundColor: widget.color,
              child: Text(
                getPrayArabicName(widget.cubit.nextPray!.name),
                textAlign: TextAlign.right,
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 22.sp,
                ),
              ),
            ),
          ],
        ),
        // SizedBox(
        //   width: 25.w,
        // ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الصلاة القادمة',
              textAlign: TextAlign.right,
              style: GoogleFonts.noticiaText(
                fontWeight: FontWeight.w400,
                fontSize: 28.sp,
                color: MyColors.darkBrown,
              ),
            ),
            Row(
              children: [
                Text(
                  '$_hours:$_minutes:$_seconds',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.noticiaText(
                    fontWeight: FontWeight.w400,
                    fontSize: 25.sp,
                    color: MyColors.darkBrown,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Image.asset(
                  timer_icon,
                  width: MediaQuery.of(context).size.width * 0.14,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 3.w,
        ),
      ],
    );
  }
}
