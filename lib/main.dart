import 'package:flutter/material.dart';

import 'package:quran_v2/splash_screen.dart';
import 'package:sizer/sizer.dart';

import 'core/utils/conestans.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await readJson();
      await readSuraNameJson();
      await getSettings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            // appBarTheme: const AppBarTheme(
            //     systemOverlayStyle: SystemUiOverlayStyle(
            //   statusBarColor: Color(0xFFE95C1F),
            //   statusBarBrightness: Brightness.light,
            //   statusBarIconBrightness: Brightness.dark,
            // )),
            ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      );
    });
  }
}
