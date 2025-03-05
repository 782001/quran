// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:quran_v2/core/network/local/cashhelper.dart';
// import 'package:quran_v2/core/responsive/screen_util.dart';
// import 'package:quran_v2/core/services/notification_helper.dart';
// import 'package:quran_v2/core/utils/app_theme_colors.dart';
// import 'package:quran_v2/core/utils/strings.dart';
// import 'package:quran_v2/presination/widgets/haltalam_widget.dart';

// class ScheduleNotificationScreen extends StatefulWidget {
//   const ScheduleNotificationScreen({super.key});

//   @override
//   _ScheduleNotificationScreenState createState() =>
//       _ScheduleNotificationScreenState();
// }

// class _ScheduleNotificationScreenState
//     extends State<ScheduleNotificationScreen> {
//   Duration halTalamselectedDuration = const Duration(minutes: 1);
//   Duration mohammedSelectedDuration = const Duration(minutes: 1);

//   bool isHalTalamScheduled = false;
//   bool isMohammedScheduled = false;
//   @override
//   void initState() {
//     super.initState();
//     loadNotificationPreferences();
//   }

//   Future<void> loadNotificationPreferences() async {
//     isHalTalamScheduled = CashHelper.GetData(key: "halTalamScheduled") ?? true;
//     isMohammedScheduled = CashHelper.GetData(key: "mohammedScheduled") ?? true;

//     setState(() {});
//   }

//   Future<void> halTalamScheduleNotification(bool value) async {
//     setState(() {
//       isHalTalamScheduled = value;
//     });
//     await CashHelper.SaveData(key: "halTalamScheduled", value: value);

//     if (value) {
//       DateTime scheduledTime = DateTime.now().add(halTalamselectedDuration);
//       await CashHelper.SaveData(
//           key: "halTalamNotificationTime",
//           value: halTalamselectedDuration.inMinutes);
//       log("halTalamSelectedDuration: $halTalamselectedDuration");
//       NotificationHelper.scheduleNotification(
//         id: 1,
//         title: 'هل تعلم',
//         body: getRandomFact(),
//         scheduledTime: scheduledTime,
//       );
//     }
//   }

//   Future<void> mohammedScheduleNotification(bool value) async {
//     setState(() {
//       isMohammedScheduled = value;
//     });
//     await CashHelper.SaveData(key: "mohammedScheduled", value: value);
//     if (value) {
//       DateTime scheduledTime = DateTime.now().add(mohammedSelectedDuration);
//       await CashHelper.SaveData(
//           key: "mohammedNotificationTime",
//           value: mohammedSelectedDuration.inMinutes);
//       NotificationHelper.scheduleNotification(
//         id: 2,
//         title: "صلي علي محمد",
//         body:
//             "إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا",
//         scheduledTime: scheduledTime,
//       );
//     }
//   }

//   String _formatDuration(Duration duration) {
//     if (duration.inMinutes == 1) return "دقيقه";
//     if (duration.inMinutes == 15) return "ربع ساعه";
//     if (duration.inMinutes == 30) return "نصف ساعه";

//     if (duration.inMinutes == 60) return "ساعه";
//     if (duration.inMinutes == 180) return "ثلاث ساعات ";
//     if (duration.inMinutes == 1440) return "يوما";
//     return "${duration.inMinutes} minutes";
//   }

//   Widget buildNotificationCard(
//       String title,
//       Duration selectedDuration,
//       ValueChanged<Duration> onDurationChanged,
//       bool isScheduled,
//       ValueChanged<bool> onSwitchChanged) {
//     return Card(
//       elevation: 5,
//       color: MyColors.creamColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title,
//                     style: TextStyle(
//                         color: MyColors.babyBrown,
//                         fontFamily: cairoFont,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold)),
//                 Switch(
//                   value: isScheduled,
//                   onChanged: onSwitchChanged,
//                   activeColor: MyColors.babyBrown,
//                 )
//               ],
//             ),
//             const SizedBox(height: 10),
//             DropdownButton<Duration>(
//               value: selectedDuration,
//               items: [
//                 const Duration(minutes: 1),
//                 const Duration(minutes: 15),
//                 const Duration(minutes: 30),
//                 const Duration(minutes: 60),
//                 const Duration(minutes: 180),
//                 const Duration(minutes: 1440),
//               ]
//                   .map((duration) => DropdownMenuItem(
//                         value: duration,
//                         child: Text(_formatDuration(duration)),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   onDurationChanged(value);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("إعدادات الإشعارات"),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               buildNotificationCard(
//                 "إشعارات هل تعلم",
//                 halTalamselectedDuration,
//                 (newDuration) {
//                   setState(() {
//                     halTalamselectedDuration = newDuration;
//                   });
//                 },
//                 isHalTalamScheduled,
//                 (bool value) {
//                   halTalamScheduleNotification(value);
//                   if (value) {
//                     NotificationHelper.requestPermissions();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('تم تفعيل الإشعارات ل "هل تعلم"'),
//                       ),
//                     );
//                   } else {
//                     NotificationHelper.cancelNotification(
//                         1); // Cancel notification
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('تم إيقاف الإشعارات ل "هل تعلم"'),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               buildNotificationCard(
//                 "إشعارات الصلاة على النبي",
//                 mohammedSelectedDuration,
//                 (newDuration) {
//                   setState(() {
//                     mohammedSelectedDuration = newDuration;
//                   });
//                 },
//                 isMohammedScheduled,
//                 (bool value) {
//                   mohammedScheduleNotification(value);
//                   if (value) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                             Text('تم تفعيل الإشعارات ل "الصلاة على النبي"'),
//                       ),
//                     );
//                   } else {
//                     NotificationHelper.cancelNotification(2);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content:
//                             Text('تم إيقاف الإشعارات ل "الصلاة على النبي"'),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_v2/core/network/local/cashhelper.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/core/services/notification_helper.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/main.dart';
import 'package:quran_v2/presination/screens/home_screen.dart';
import 'package:quran_v2/presination/widgets/haltalam_widget.dart';

class ScheduleNotificationScreen extends StatefulWidget {
  const ScheduleNotificationScreen({super.key});

  @override
  _ScheduleNotificationScreenState createState() =>
      _ScheduleNotificationScreenState();
}

class _ScheduleNotificationScreenState
    extends State<ScheduleNotificationScreen> {
  int halTalamselectedDuration =
      CashHelper.GetData(key: "halTalamNotificationTime") ?? 15;
  int mohammedSelectedDuration =
      CashHelper.GetData(key: "mohammedNotificationTime") ?? 15;
  int customSelectedDuration =
      CashHelper.GetData(key: "customNotificationTime") ?? 15;
  int azkartagSelectedDuration =
      CashHelper.GetData(key: "azkartagNotificationTime") ?? 15;
  int ayaSelectedDuration =
      CashHelper.GetData(key: "ayaNotificationTime") ?? 15;
  final Random random = Random();

  bool isHalTalamScheduled = true;
  bool isMohammedScheduled = true;
  bool isCustomScheduled = true;
  bool isazkartagScheduled = false;
  bool isayaScheduled = false;

  TextEditingController customMessageController = TextEditingController();
  Future<void> checkAndShowPermissionDialog() async {
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPermissionDialog(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkAndShowPermissionDialog();
    loadNotificationPreferences();
    halTalamScheduleNotification(isHalTalamScheduled);
    mohammedScheduleNotification(isMohammedScheduled);
    customScheduleNotification(isCustomScheduled);
    azkartagScheduleNotification(isazkartagScheduled);
    ayaScheduleNotification(isayaScheduled);
  }

  Future<void> loadNotificationPreferences() async {
    isHalTalamScheduled = CashHelper.GetData(key: "halTalamScheduled") ?? true;
    isMohammedScheduled = CashHelper.GetData(key: "mohammedScheduled") ?? true;
    isCustomScheduled = CashHelper.GetData(key: "customScheduled") ?? true;
    isazkartagScheduled = CashHelper.GetData(key: "azkartagScheduled") ?? true;
    isayaScheduled = CashHelper.GetData(key: "ayaScheduled") ?? true;
    customMessageController.text =
        CashHelper.GetData(key: "customMessage") ?? "";

    setState(() {});
  }

  Future<void> halTalamScheduleNotification(bool value) async {
    setState(() {
      isHalTalamScheduled = value;
    });

    await CashHelper.SaveData(key: "halTalamScheduled", value: value);

    if (value) {
      NotificationHelper.cancelNotification(1);
      int scheduledTime = halTalamselectedDuration;
      await CashHelper.SaveData(
          key: "halTalamNotificationTime", value: halTalamselectedDuration);
      NotificationHelper.scheduleNotification(
        id: 1,
        title: 'هل تعلم',
        body: getRandomFact(),
        intervalMinutes: scheduledTime,
      );
    } else {
      NotificationHelper.cancelNotification(1);
    }
  }

  Future<void> mohammedScheduleNotification(bool value) async {
    setState(() {
      isMohammedScheduled = value;
    });

    await CashHelper.SaveData(key: "mohammedScheduled", value: value);

    if (value) {
      NotificationHelper.cancelNotification(2);
      int scheduledTime = mohammedSelectedDuration;
      await CashHelper.SaveData(
          key: "mohammedNotificationTime", value: mohammedSelectedDuration);
      NotificationHelper.scheduleNotification(
        id: 2,
        title: "صلي علي محمد",
        body:
            "إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا",
        intervalMinutes: scheduledTime,
      );
    } else {
      NotificationHelper.cancelNotification(2);
    }
  }

  Future<void> customScheduleNotification(bool value) async {
    setState(() {
      isCustomScheduled = value;
    });

    await CashHelper.SaveData(key: "customScheduled", value: value);

    if (value) {
      NotificationHelper.cancelNotification(3);
      String customMessage = customMessageController.text.trim();
      if (customMessage.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء إدخال رسالة مخصصة')),
        );
        return;
      }

      await CashHelper.SaveData(key: "customMessage", value: customMessage);

      int scheduledTime = customSelectedDuration;
      await CashHelper.SaveData(
          key: "customNotificationTime", value: customSelectedDuration);

      NotificationHelper.scheduleNotification(
        id: 3,
        title: "إشعار مخصص لك",
        body: customMessage.isEmpty ? "يمكنك إضافة رسالة مخصصة" : customMessage,
        intervalMinutes: scheduledTime,
      );
    } else {
      NotificationHelper.cancelNotification(3);
    }
  }

  Future<void> azkartagScheduleNotification(bool value) async {
    setState(() {
      isazkartagScheduled = value;
    });

    await CashHelper.SaveData(key: "azkartagScheduled", value: value);
    Map<String, String> adhkar = getRandomAdhkar();
    if (value) {
      NotificationHelper.cancelNotification(4);
      int scheduledTime = azkartagSelectedDuration;
      await CashHelper.SaveData(
          key: "azkartagNotificationTime", value: azkartagSelectedDuration);
      NotificationHelper.scheduleNotification(
        id: 4,
        title: adhkar["title"]!,
        body: adhkar["body"]!,
        intervalMinutes: scheduledTime,
      );
    } else {
      NotificationHelper.cancelNotification(4);
    }
  }

  Future<void> ayaScheduleNotification(bool value) async {
    setState(() {
      isayaScheduled = value;
    });
    int randomSurah = random.nextInt(114) + 1; // Random Surah from 1 to 114
    int totalVerses = quran.getVerseCount(
        randomSurah); // Get the number of verses in the selected Surah
    int randomVerse =
        random.nextInt(totalVerses) + 1; // Random verse within the valid range

    String verse =
        quran.getVerse(randomSurah, randomVerse, verseEndSymbol: true);
    await CashHelper.SaveData(key: "ayaScheduled", value: value);

    if (value) {
      NotificationHelper.cancelNotification(5);
      int scheduledTime = ayaSelectedDuration;
      await CashHelper.SaveData(
          key: "ayaNotificationTime", value: ayaSelectedDuration);
      NotificationHelper.scheduleNotification(
        id: 5,
        title: "أيات من الذكر الحكيم",
        body: verse,
        intervalMinutes: scheduledTime,
      );
    } else {
      NotificationHelper.cancelNotification(5);
    }
  }

  String _formatDuration(int duration) {
    // if (duration == 1) return "دقيقه";
    if (duration == 15) return "ربع ساعه";
    if (duration == 30) return "نصف ساعه";
    if (duration == 60) return "ساعه";
    if (duration == 180) return "ثلاث ساعات ";
    if (duration == 1440) return "يوما";
    return "$duration دقائق";
  }

  Widget buildNotificationCard(
      String title,
      int selectedDuration,
      ValueChanged<int> onDurationChanged,
      bool isScheduled,
      ValueChanged<bool> onSwitchChanged,
      {Widget? customField}) {
    return Card(
      elevation: 5,
      color: MyColors.creamColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: MyColors.babyBrown,
                        fontFamily: cairoFont,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold)),
                Switch(
                  value: isScheduled,
                  onChanged: onSwitchChanged,
                  activeColor: MyColors.babyBrown,
                )
              ],
            ),
            if (customField != null) ...[
              const SizedBox(height: 10),
              customField,
            ],
            const SizedBox(height: 10),
            DropdownButton<int>(
              value: selectedDuration,
              items: [
                // 1,
                15,
                30,
                60,
                180,
                1440,
              ]
                  .map((duration) => DropdownMenuItem(
                        value: duration,
                        child: Text(_formatDuration(duration)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onDurationChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إعدادات الإشعارات"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildNotificationCard(
                    "إشعارات هل تعلم",
                    halTalamselectedDuration,
                    // (newDuration) {
                    //   setState(() {
                    //     halTalamselectedDuration = newDuration;
                    //   });
                    // },
                    (newDuration) {
                      setState(() {
                        halTalamselectedDuration = newDuration;
                      });

                      // Reschedule the notification immediately when duration changes
                      if (isHalTalamScheduled) {
                        halTalamScheduleNotification(true);
                      }
                    },
                    isHalTalamScheduled,
                    (bool value) {
                      halTalamScheduleNotification(value);
                      if (value) {
                        checkAndShowPermissionDialog();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تفعيل الإشعارات ل "هل تعلم"'),
                          ),
                        );
                      } else {
                        NotificationHelper.cancelNotification(
                            1); // Cancel notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إيقاف الإشعارات ل "هل تعلم"'),
                          ),
                        );
                      }
                    }),
                const SizedBox(height: 10),
                buildNotificationCard(
                  "إشعارات الصلاة على النبي",
                  mohammedSelectedDuration,
                  (newDuration) {
                    setState(() {
                      mohammedSelectedDuration = newDuration;
                    });
                    // Reschedule the notification immediately when duration changes
                    if (isMohammedScheduled) {
                      mohammedScheduleNotification(true);
                    }
                  },
                  isMohammedScheduled,
                  (bool value) {
                    mohammedScheduleNotification(value);
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('تم تفعيل الإشعارات ل "الصلاة على النبي"'),
                        ),
                      );
                    } else {
                      NotificationHelper.cancelNotification(2);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('تم إيقاف الإشعارات ل "الصلاة على النبي"'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                buildNotificationCard(
                  "إشعار مخصص",
                  customSelectedDuration,
                  (newDuration) {
                    setState(() {
                      customSelectedDuration = newDuration;
                    }); // Reschedule the notification immediately when duration changes
                    if (isCustomScheduled) {
                      NotificationHelper.cancelNotification(3)
                          .then((value) => customScheduleNotification(true));
                    }
                  },
                  isCustomScheduled,
                  (bool value) {
                    customScheduleNotification(value);
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم تفعيل الإشعارات المخصصه'),
                        ),
                      );
                    } else {
                      NotificationHelper.cancelNotification(3);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إيقاف الإشعارات المخصصه'),
                        ),
                      );
                    }
                  },
                  customField: TextField(
                    controller: customMessageController,
                    decoration: const InputDecoration(
                      labelText: "اكتب رسالتك هنا",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildNotificationCard(
                    "إشعارات التيجان السبعة",
                    azkartagSelectedDuration,
                    // (newDuration) {
                    //   setState(() {
                    //     halTalamselectedDuration = newDuration;
                    //   });
                    // },
                    (newDuration) {
                      setState(() {
                        azkartagSelectedDuration = newDuration;
                      });

                      // Reschedule the notification immediately when duration changes
                      if (isazkartagScheduled) {
                        azkartagScheduleNotification(true);
                      }
                    },
                    isazkartagScheduled,
                    (bool value) {
                      azkartagScheduleNotification(value);
                      if (value) {
                        checkAndShowPermissionDialog();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('تم تفعيل الإشعارات ل "التيجان السبعة"'),
                          ),
                        );
                      } else {
                        NotificationHelper.cancelNotification(
                            1); // Cancel notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('تم إيقاف الإشعارات ل "التيجان السبعة"'),
                          ),
                        );
                      }
                    }),
                const SizedBox(height: 10),
                buildNotificationCard(
                    "إشعارات الايات القرانيه ",
                    ayaSelectedDuration,
                    // (newDuration) {
                    //   setState(() {
                    //     halTalamselectedDuration = newDuration;
                    //   });
                    // },
                    (newDuration) {
                      setState(() {
                        ayaSelectedDuration = newDuration;
                      });

                      // Reschedule the notification immediately when duration changes
                      if (isayaScheduled) {
                        ayaScheduleNotification(true);
                      }
                    },
                    isayaScheduled,
                    (bool value) {
                      ayaScheduleNotification(value);
                      if (value) {
                        checkAndShowPermissionDialog();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('تم تفعيل الإشعارات ل "الايات القرانيه"'),
                          ),
                        );
                      } else {
                        NotificationHelper.cancelNotification(
                            1); // Cancel notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('تم إيقاف الإشعارات ل "الايات القرانيه"'),
                          ),
                        );
                      }
                    }),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
