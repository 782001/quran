import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';

class NoBookMarkScreen extends StatelessWidget {
  const NoBookMarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Center(
            child: Text(
          "لا يوجد آيات مضافه",
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.05,
            color: Colors.grey,
          ),
          textDirection: TextDirection.rtl,
        )));
  }
}
