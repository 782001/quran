import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/conestans.dart';

class NoBookMarkScreen extends StatelessWidget {
  const NoBookMarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xffFFFBE8),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Icon(
                  Icons.do_not_disturb_alt_sharp,
                  size: 60,
                  color: Color(0xffE95C1F),
                ),
                const Spacer(
                    // height: 20,
                    ),
                Text(
                  "لا يوجد آيات مضافه",
                  style: TextStyle(
                    fontFamily: quranFont,
                    fontSize: arabicFontSize,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
