import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(settings); // Request permissions
    // await requestPermissions();
  }

  /// Request Notification Permissions

  /// cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  ///If i want to cancel all notifications,
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    initNotifications();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id 3',
      'CRChannelName',
      channelDescription: 'CRChanelDescription',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      ticker: 'ticker',
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

// Schedule Notification Function
  // static Future<void> scheduleNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledTime,
  // }) async {
  //   initNotifications();
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'quran_channel_id',
  //     'Quran Notifications',
  //     channelDescription: 'Quran reading reminders',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails details = NotificationDetails(
  //     android: androidDetails,
  //   );

  //   await _notificationsPlugin.periodicallyShow(
  //     id,
  //     title,
  //     body,
  //     // convertToTZDateTime(scheduledTime), // Convert DateTime to TZDateTime
  //     RepeatInterval.everyMinute, // First notification after 10 sec

  //     details,
  //     // uiLocalNotificationDateInterpretation:
  //     //     UILocalNotificationDateInterpretation.absoluteTime,
  //     androidScheduleMode: AndroidScheduleMode
  //         .exactAllowWhileIdle, // FIX: Required parameter added
  //     // matchDateTimeComponents:
  //     //     DateTimeComponents.second, // Repeat every second (or use minute/hour)
  //   );
  // }

  // static Future<void> scheduleNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledTime,
  // }) async {
  //   // Initialize timezone data
  //   tz.initializeTimeZones();

  //   final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
  //     scheduledTime,
  //     tz.local,
  //   );

  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'quran_channel_id',
  //     'Quran Notifications',
  //     channelDescription: 'Quran reading reminders',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails details = NotificationDetails(
  //     android: androidDetails,
  //   );

  //   await _notificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     scheduledDate,
  //     details,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents:
  //         DateTimeComponents.time, // Ensures daily repeat at the same time
  //   );
  // }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int intervalMinutes, // Custom interval in minutes
  }) async {
    initNotifications();

    // Initialize timezone data
    tz.initializeTimeZones();

    // Get the next scheduled time
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(
      Duration(minutes: intervalMinutes),
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'quran_channel_id',
      'Quran Notifications',
      channelDescription: 'Quran reading reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Reschedule the notification after it triggers
    Future.delayed(Duration(minutes: intervalMinutes), () {
      scheduleNotification(
        id: id,
        title: title,
        body: body,
        intervalMinutes: intervalMinutes,
      );
    });
  }
}
