// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:medtrack/app_module/prescription_module/model/prescription_model.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

// class NotificationService extends GetxService {
//   static Future<void> init() async {
//     AwesomeNotifications().initialize(
//         null,
//         [
//           NotificationChannel(
//               channelKey: 'basic_channel',
//               channelName: 'notifications',
//               channelDescription: 'Channel for alarm notifications',
//               importance: NotificationImportance.High,
//               channelShowBadge: true,
//               playSound: true,
//               criticalAlerts: true,
//               ledColor: Colors.yellow),
//         ],
//         debug: true);
//   }

//   @pragma("vm:entry-point")
//   Future<void> scheduleNotifications({List<PrescriptionModel>? drugs}) async {
//     final existingAlarms = await AwesomeNotifications().listScheduledNotifications();
//     final now = DateTime.now();
//     for (final prescription in drugs!) {
//       if (prescription == null) {
//         debugPrint('Cannot schedule alarm for null prescription');
//         continue;
//       }

//       final alarmId = prescription.id;
//       if (existingAlarms.any((alarm) => alarm.content?.id == alarmId)) {
//         debugPrint('Skipping alarm scheduling for existing id: $alarmId');
//         continue;
//       }

//       final startDate = prescription.startDate;
//       final endDate = prescription.endDate;
//       final alarmTimeHour = prescription.time.hour;
//       final alarmTimeMin = prescription.time.minute;
//       final name = prescription.name;

//       if (startDate != null && endDate != null) {
//         for (var date = startDate;
//         date.isBefore(endDate.add(const Duration(days: 1)));
//         date = date.add(const Duration(days: 1))) {
//           final alarmId = prescription.id;

//           final alarmDateTime = DateTime(
//             date.isAfter(startDate) && date.isBefore(endDate)
//                 ? date.year
//                 : startDate.year,
//             date.isAfter(startDate) && date.isBefore(endDate)
//                 ? date.month
//                 : startDate.month,
//             date.isAfter(startDate) && date.isBefore(endDate)
//                 ? date.day
//                 : startDate.day,
//             alarmTimeHour,
//             alarmTimeMin,
//           );
//           if (alarmDateTime.isBefore(now)) {
//             continue;
//           }

//           debugPrint('Scheduling alarm with id $alarmId');
//           await AwesomeNotifications().createNotification(
//             content: NotificationContent(
//               id: alarmId!,
//               title: 'MedTime!',
//               actionType: ActionType.Default,
//               autoDismissible: true,
//               body: 'It\'s time to take your $name medicine!',
//               notificationLayout: NotificationLayout.Default,
//               channelKey: 'basic_channel',
//               displayOnBackground: true,
//               displayOnForeground: true,
//             ),
//             schedule: NotificationCalendar(
//               weekday: alarmDateTime.weekday,
//               day: alarmDateTime.day,
//               month: alarmDateTime.month,
//               hour: alarmDateTime.hour,
//               minute: alarmDateTime.minute,
//               second: 0,
//               millisecond: 0,
//               repeats: true,
//               allowWhileIdle: true,
//               preciseAlarm: true,
//               timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//             ),
//           ).then((_) {
//             debugPrint('Alarm scheduled for $alarmDateTime');
//           }).catchError((e) {
//             debugPrint('Error scheduling alarm: $e');
//           });
//         }
//       } else {
//         debugPrint('Cannot schedule alarm without start and end dates');
//       }
//     }
//   }

//   Future<void> cancelAlarms(int id) async {

//       try {
//         await AwesomeNotifications().cancel(id);
//         debugPrint('Canceled alarm with id $id');
//       } catch (e) {
//         debugPrint('Error canceling alarm: $e');
//       }
//     }

// }