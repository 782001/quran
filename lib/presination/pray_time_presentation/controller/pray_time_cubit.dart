import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quran_v2/core/network/local/cashhelper.dart';
import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/core/utils/strings.dart';

part 'pray_time_state.dart';

class PrayTimeCubit extends Cubit<PrayTimeState> {
  PrayTimeCubit() : super(PrayTimeInitial());
  static PrayTimeCubit get(context) => BlocProvider.of(context);

  //PrayerDataModel? prayTimeData;
  //final PrayTimeUseCase prayTimeUseCase;

  // Future<void> fetchPrayData({
  //   required String country,
  //   required String date,
  // }) async {
  //   emit(PrayTimeLoadingFetchData());
  //   testPrayTime();
  //   var result = await prayTimeUseCase
  //       .execute(
  //     country: country,
  //     date: date,
  //   )
  //       .catchError((error) {
  //     emit(PrayTimeErrorFetchData());
  //     print("emited success");
  //     print(error.toString());
  //   });
  //   result.fold((failure) {
  //     emit(PrayTimeErrorFetchData());
  //   }, (data) {
  //     prayTimeData = data;
  //     print("----------------------");
  //     //print(prayTimeData?.data['timings']);
  //     emit(PrayTimeSuccessFetchData(data));
  //   });
  // }

  Prayer? nextPray;
  DateTime? timeForNextPray;

  // void onMessageListen(context) {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       print("------------------------");
  //       print(message.notification!.title);
  //       print("-------------------------");
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("${message.notification!.body}",
  //               textAlign: TextAlign.right),
  //           backgroundColor: MyColors.darkBrown,
  //           behavior: SnackBarBehavior.floating,
  //         ),
  //       );
  //     }
  //   });
  // }

  Future<void> fetchPrayData(context) async {
    // CashHelper.removeData(key: AppStrings.latKey);
    // CashHelper.removeData(key: AppStrings.longKey);
    print('My Prayer Times');
    // log('${CashHelper.GetData(key: AppStrings.latKey)}');
    try {
      //onMessageListen(context);
      emit(PrayTimeLoadingFetchData());
      //setup pray times
      final myCoordinates = Coordinates(
        CashHelper.GetData(key: AppStrings.latKey),
        CashHelper.GetData(key: AppStrings.longKey),
      ); // Replace with your own location lat, lng.
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;
      final prayerTimes = PrayerTimes.today(myCoordinates, params);
      nextPray = prayerTimes.nextPrayer() == Prayer.none
          ? Prayer.fajr
          : prayerTimes.nextPrayer();
      timeForNextPray = prayerTimes.timeForPrayer(nextPray!);
      print("nextPray");
      print(nextPray);
      print("timeForNextPray");
      print(timeForNextPray);

      print("${prayerTimes.fajr.hour}:${prayerTimes.fajr.minute}");
      DateTime fajrDateTime = DateTime.parse(prayerTimes.fajr.toString());

      fajrTime = convertTo12HourFormat(fajrDateTime);
      // "${prayerTimes.fajr.hour}:${prayerTimes.fajr.minute}";
      DateTime shroukDateTime = DateTime.parse(prayerTimes.sunrise.toString());
      shroukTime = convertTo12HourFormat(shroukDateTime);
      DateTime duhrDateTime = DateTime.parse(prayerTimes.dhuhr.toString());

      duhrTime = convertTo12HourFormat(duhrDateTime);
      DateTime asrDateTime = DateTime.parse(prayerTimes.asr.toString());
      asrTime = convertTo12HourFormat(asrDateTime);
      DateTime maghrbDateTime = DateTime.parse(prayerTimes.maghrib.toString());
      maghrbTime = convertTo12HourFormat(maghrbDateTime);
      DateTime ishaDateTime = DateTime.parse(prayerTimes.isha.toString());
      ishaTime = convertTo12HourFormat(ishaDateTime);
      // "${prayerTimes.isha.hour}:${prayerTimes.isha.minute}";
      emit(PrayTimeSuccessFetchData());
    } catch (error) {
      log("$error");
      emit(PrayTimeErrorFetchData());
    }
    //print(prayerTimes.fajr);
    // print(DateFormat.jm().format(prayerTimes.sunrise));
    // print(DateFormat.jm().format(prayerTimes.dhuhr));
    // print(DateFormat.jm().format(prayerTimes.asr));
    // print(DateFormat.jm().format(prayerTimes.maghrib));
    // print(DateFormat.jm().format(prayerTimes.isha));
  }

  Future<void> fetchFromApi() async {
    const String url = 'https://quran.yousefheiba.com/api/getPrayerTimes';
    print('My Prayer Times');
    try {
      emit(PrayTimeLoadingFetchData());
      Response response = await Dio().get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        DateTime fajrDateTime =
            createDateTimeFromTime(data['prayer_times']['Fajr']);
        log("$fajrDateTime");
        fajrTime = convertTo12HourFormat(fajrDateTime);
        // fajrTime = data['prayer_times']['Fajr'];
        DateTime shroukDateTime =
            createDateTimeFromTime(data['prayer_times']['Sunrise']);
        shroukTime = convertTo12HourFormat(shroukDateTime);
        // shroukTime = data['prayer_times']['Sunrise'];
        DateTime duhrDateTime =
            createDateTimeFromTime(data['prayer_times']['Dhuhr']);

        duhrTime = convertTo12HourFormat(duhrDateTime);
        // duhrTime = data['prayer_times']['Dhuhr'];
        DateTime asrDateTime =
            createDateTimeFromTime(data['prayer_times']['Asr']);
        asrTime = convertTo12HourFormat(asrDateTime);

        // asrTime = data['prayer_times']['Asr'];
        DateTime maghrbDateTime =
            createDateTimeFromTime(data['prayer_times']['Maghrib']);
        maghrbTime = convertTo12HourFormat(maghrbDateTime);

        // maghrbTime = data['prayer_times']['Maghrib'];
        DateTime ishaDateTime =
            createDateTimeFromTime(data['prayer_times']['Isha']);
        ishaTime = convertTo12HourFormat(ishaDateTime);

        // ishaTime = data['prayer_times']['Isha'];
        Map<Prayer, String> prayerTimes = {
          Prayer.fajr: data['prayer_times']["Fajr"],
          Prayer.dhuhr: data['prayer_times']["Dhuhr"],
          Prayer.asr: data['prayer_times']["Asr"],
          Prayer.maghrib: data['prayer_times']["Maghrib"],
          Prayer.isha: data['prayer_times']["Isha"]
        };

        // Get the next prayer
        determineNextPrayer(prayerTimes);
        emit(PrayTimeSuccessFetchData());
      } else {
        emit(PrayTimeErrorFetchDataAPI());
      }
    } catch (error) {
      log("API Fetch Error: $error");
      emit(PrayTimeErrorFetchDataAPI());
    }
  }

  void determineNextPrayer(Map<Prayer, String> prayerTimes) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("HH:mm");

    for (var entry in prayerTimes.entries) {
      DateTime prayerTime = format.parse(entry.value);
      prayerTime = DateTime(
          now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);

      if (prayerTime.isAfter(now)) {
        nextPray = entry.key; // Assign Prayer enum instead of String
        timeForNextPray = prayerTime;
        break;
      }
    }

    // If all prayers have passed, set Fajr as the next prayer for the next day
    if (nextPray == null) {
      nextPray = Prayer.fajr;
      timeForNextPray = DateFormat("HH:mm").parse(prayerTimes[Prayer.fajr]!);
      timeForNextPray = timeForNextPray!.add(const Duration(days: 1));
    }

    log("Next Prayer: $nextPray at $timeForNextPray");
  }

  String convertTo12HourFormat(DateTime dateTime) {
    String formattedTime = DateFormat(
      "h:mm a",
    ).format(dateTime); // Replace AM/PM with Arabic equivalents
    formattedTime = formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');
    return formattedTime;

    // 12-hour format
  }

  DateTime createDateTimeFromTime(String time) {
    List<String> parts = time.split(':'); // Split "04:50" into ["04", "50"]
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    return DateTime(2000, 1, 1, hours, minutes); // Use a dummy date
  }
}
