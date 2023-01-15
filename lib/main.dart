import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/presination/controller/app_cubit.dart';
import 'package:quran/presination/screens/HomeScreen.dart';
import 'package:sizer/sizer.dart';

import 'core/shared/components.dart';
import 'core/utils/conestans.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await readJson();
      await getSettings();
    });
    super.initState();
  }

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
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(196, 196, 196, 0),
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            )),
            primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      );
    });
  }
}
