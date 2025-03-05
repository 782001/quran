import 'dart:math';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_v2/core/network/local/cashhelper.dart';
import 'package:quran_v2/core/services/notification_helper.dart';
import 'package:quran_v2/presination/controller/app_cubit.dart';
import 'package:quran_v2/presination/pray_time_presentation/controller/pray_time_cubit.dart';
import 'package:quran_v2/presination/widgets/haltalam_widget.dart';
import 'package:quran_v2/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'core/utils/conestans.dart';

@pragma('vm:entry-point')
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    print("message>>>>>>>>>>>>>>>>>>>>>>>> ");
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    await CashHelper.init();
    await NotificationHelper.initNotifications();
    ////////////////////
    ///

    ///

    bool isHalTalamScheduled =
        CashHelper.GetData(key: "halTalamScheduled") ?? true;
    bool isMohammedScheduled =
        CashHelper.GetData(key: "mohammedScheduled") ?? true;
    bool isCustomScheduled = CashHelper.GetData(key: "customScheduled") ?? true;
    bool isazkartagScheduled =
        CashHelper.GetData(key: "azkartagScheduled") ?? true;
    bool isayaScheduled = CashHelper.GetData(key: "ayaScheduled") ?? true;

    int halTalamselectedMinutes =
        CashHelper.GetData(key: "halTalamNotificationTime") ?? 15;
    int MohammedselectedMinutes =
        CashHelper.GetData(key: "mohammedNotificationTime") ?? 15;
    int customselectedMinutes =
        CashHelper.GetData(key: "customNotificationTime") ?? 15;
    int azkartagselectedMinutes =
        CashHelper.GetData(key: "azkartagNotificationTime") ?? 15;
    int ayaselectedMinutes =
        CashHelper.GetData(key: "ayaNotificationTime") ?? 15;

    //////////////

    /// Schedule only if enabled, otherwise cancel
    if (isHalTalamScheduled) {
      NotificationHelper.scheduleNotification(
        id: 1,
        title: 'هل تعلم؟',
        body: getRandomFact(),
        intervalMinutes: halTalamselectedMinutes,
      );
    } else {
      NotificationHelper.cancelNotification(1);
    }

    //////////////////////////////////////
    ///
    ///
    ///

    if (isMohammedScheduled) {
      NotificationHelper.scheduleNotification(
        id: 2,
        title: "صلي علي محمد",
        body:
            "إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا",
        intervalMinutes: MohammedselectedMinutes,
      );
    } else {
      NotificationHelper.cancelNotification(2);
    }
    //////////////////////////////////////
    ///
    ///
    ///

    if (isCustomScheduled) {
      String customMessage = CashHelper.GetData(key: "customMessage") ?? "";
      NotificationHelper.scheduleNotification(
        id: 3,
        title: "اشعار مخصص لك ",
        body: customMessage.isEmpty ? "يمكنك إضافة رسالة مخصصة" : customMessage,
        intervalMinutes: customselectedMinutes,
      );
    } else {
      NotificationHelper.cancelNotification(3);
    }

    //////////////////////////////////////
    ///
    ///
    ///
    ///
    if (isazkartagScheduled) {
      Map<String, String> adhkar = getRandomAdhkar();
      NotificationHelper.scheduleNotification(
        id: 4,
        title: adhkar["title"]!,
        body: adhkar["body"]!,
        intervalMinutes: azkartagselectedMinutes,
      );
    } else {
      NotificationHelper.cancelNotification(4);
    }

    ///////////////////
    ///
    ///
    ///
    ///
    ///

    if (isayaScheduled) {
      final Random random = Random();
      int randomSurah = random.nextInt(114) + 1;
      int totalVerses = quran.getVerseCount(randomSurah);
      int randomVerse = random.nextInt(totalVerses) + 1;
      String verse =
          quran.getVerse(randomSurah, randomVerse, verseEndSymbol: true);

      NotificationHelper.scheduleNotification(
        id: 5,
        title: "آية من القرآن",
        body: verse,
        intervalMinutes: ayaselectedMinutes,
      );
    } else {
      NotificationHelper.cancelNotification(5);
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.quran.quran_v2.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'drawable/ic_launcher',
    // androidNotificationIcon: "drawable/notification_icon", // Use the icon name (without extension)
  );
  // Initialize timezones
  tz.initializeTimeZones();
  await CashHelper.init();
  await NotificationHelper.initNotifications();
  // Initialize WorkManager
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, // Set to false in production
  );

  // Schedule background tasks
  Workmanager().registerPeriodicTask(
    "scheduled_notifications",
    "show_notifications",
    frequency: const Duration(minutes: 15), // Min interval is 15 min on Android
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
     super.initState();   WidgetsBinding.instance.addPostFrameCallback((_) async {
      await readJson();
      await readSuraNameJson();
      await getSettings();

    });

    NotificationHelper();
  }
 @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppCubit()..initState(bookmarkedAyah),
          ),
          BlocProvider(
            create: (context) => PrayTimeCubit()..fetchPrayData(context),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
              // statusBarColor: Colors.white,
              // statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
            )),
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      );
    });
  }
}

tz.TZDateTime convertToTZDateTime(DateTime dateTime) {
  return tz.TZDateTime.from(dateTime, tz.local);
}

class QuranData {
  static List<List<int>> HizbQaurter = [
    // [sura, aya]
    [],
    [1, 1], [2, 26], [2, 44], [2, 60],
    [2, 75], [2, 92], [2, 106], [2, 124],
    [2, 142], [2, 158], [2, 177], [2, 189],
    [2, 203], [2, 219], [2, 233], [2, 243],
    [2, 253], [2, 263], [2, 272], [2, 283],
    [3, 15], [3, 33], [3, 52], [3, 75],
    [3, 93], [3, 113], [3, 133], [3, 153],
    [3, 171], [3, 186], [4, 1], [4, 12],
    [4, 24], [4, 36], [4, 58], [4, 74],
    [4, 88], [4, 100], [4, 114], [4, 135],
    [4, 148], [4, 163], [5, 1], [5, 12],
    [5, 27], [5, 41], [5, 51], [5, 67],
    [5, 82], [5, 97], [5, 109], [6, 13],
    [6, 36], [6, 59], [6, 74], [6, 95],
    [6, 111], [6, 127], [6, 141], [6, 151],
    [7, 1], [7, 31], [7, 47], [7, 65],
    [7, 88], [7, 117], [7, 142], [7, 156],
    [7, 171], [7, 189], [8, 1], [8, 22],
    [8, 41], [8, 61], [9, 1], [9, 19],
    [9, 34], [9, 46], [9, 60], [9, 75],
    [9, 93], [9, 111], [9, 122], [10, 11],
    [10, 26], [10, 53], [10, 71], [10, 90],
    [11, 6], [11, 24], [11, 41], [11, 61],
    [11, 84], [11, 108], [12, 7], [12, 30],
    [12, 53], [12, 77], [12, 101], [13, 5],
    [13, 19], [13, 35], [14, 10], [14, 28],
    [15, 1], [15, 50], [16, 1], [16, 30],
    [16, 51], [16, 75], [16, 90], [16, 111],
    [17, 1], [17, 23], [17, 50], [17, 70],
    [17, 99], [18, 17], [18, 32], [18, 51],
    [18, 75], [18, 99], [19, 22], [19, 59],
    [20, 1], [20, 55], [20, 83], [20, 111],
    [21, 1], [21, 29], [21, 51], [21, 83],
    [22, 1], [22, 19], [22, 38], [22, 60],
    [23, 1], [23, 36], [23, 75], [24, 1],
    [24, 21], [24, 35], [24, 53], [25, 1],
    [25, 21], [25, 53], [26, 1], [26, 52],
    [26, 111], [26, 181], [27, 1], [27, 27],
    [27, 56], [27, 82], [28, 12], [28, 29],
    [28, 51], [28, 76], [29, 1], [29, 26],
    [29, 46], [30, 1], [30, 31], [30, 54],
    [31, 22], [32, 11], [33, 1], [33, 18],
    [33, 31], [33, 51], [33, 60], [34, 10],
    [34, 24], [34, 46], [35, 15], [35, 41],
    [36, 28], [36, 60], [37, 22], [37, 83],
    [37, 145], [38, 21], [38, 52], [39, 8],
    [39, 32], [39, 53], [40, 1], [40, 21],
    [40, 41], [40, 66], [41, 9], [41, 25],
    [41, 47], [42, 13], [42, 27], [42, 51],
    [43, 24], [43, 57], [44, 17], [45, 12],
    [46, 1], [46, 21], [47, 10], [47, 33],
    [48, 18], [49, 1], [49, 14], [50, 27],
    [51, 31], [52, 24], [53, 26], [54, 9],
    [55, 1], [56, 1], [56, 75], [57, 16],
    [58, 1], [58, 14], [59, 11], [60, 7],
    [62, 1], [63, 4], [65, 1], [66, 1],
    [67, 1], [68, 1], [69, 1], [70, 19],
    [72, 1], [73, 20], [75, 1], [76, 19],
    [78, 1], [80, 1], [82, 1], [84, 1],
    [87, 1], [90, 1], [94, 1], [100, 9],
    [115, 1]
  ];
  static Map<String, int> getHizbAndQuarter(int sura, int aya) {
    int hizbIndex = 0;

    // Find the closest previous hizb quarter
    for (int i = 1; i < HizbQaurter.length; i++) {
      if (sura > HizbQaurter[i][0] ||
          (sura == HizbQaurter[i][0] && aya >= HizbQaurter[i][1])) {
        hizbIndex = i;
      } else {
        break;
      }
    }

    int hizbNumber = (hizbIndex / 4).ceil(); // Convert to 1-based index
    int quarter = (hizbIndex % 4 == 0)
        ? 4
        : hizbIndex % 4; // 0 = 1st quarter, 1 = 2nd, etc.

    return {
      "hizb": hizbNumber,
      "quarter": quarter == 0 ? quarter + 1 : quarter
    }; // Adjust quarter index
  }
}

final List<Map<String, String>> adhkarList = [
  {
    "title": "تاج التوحيد",
    "body":
        "لا إله إلا الله وحده لا شريك له له الملك وله الحمد و هو على كل شيء قدير"
  },
  {
    "title": "تاج التسبيح",
    "body": "سبحان الله و بحمده عدد خلقه ورضا نفسه وزنة عرشه و مداد كلماته"
  },
  {
    "title": "تاج الدعاء",
    "body": "ربنا آتنا في الدنيا حسنة و في الآخرة حسنة و قنا عذاب النار"
  },
  {
    "title": "تاج الاستغفار",
    "body":
        "اللهم أنت ربي ﻻ إله إﻻ أنت ، خلقتني وأنا عبدك ، و أنا على عهدك و وعدك ما استطعت ، أعوذ بك من شر ما صنعت ، أبوء لك بنعمتك عليّ، و أبوء بذنبي فاغفر لي فإنه ﻻ يغفر الذنوب إﻻ أنت"
  },
  {
    "title": "تاج التحصين",
    "body":
        "بسم الله الذي لا يضر مع اسمه شئ في الارض ولا في السماء وهو السميع العليم"
  },
  {
    "title": "تاج تفريج الكرب",
    "body": "لا إله إلا أنت سبحانك إني كنت من الظالمين"
  },
  {"title": "تاج راحة البال", "body": "لا حول ولا قوة الا بالله العلي العظيم"}
];
Map<String, String> getRandomAdhkar() {
  final random = Random();
  return adhkarList[random.nextInt(adhkarList.length)];
}
