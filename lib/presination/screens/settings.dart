import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/core/utils/assets_path.dart';
import 'package:quran/presination/controller/app_cubit.dart';

import '../../core/shared/components.dart';
import '../../core/utils/conestans.dart';
import '../controller/app_states.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الاعدادات",
        ),
        backgroundColor: const Color.fromARGB(196, 196, 196, 0),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'حجم الخط العربي:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Slider(
                  value: arabicFontSize,
                  min: 20,
                  max: 40,
                  onChanged: (value) {
                    setState(() {
                      arabicFontSize = value;
                    });
                  },
                ),
                Text(
                  "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                  style: TextStyle(
                      fontFamily: quranFont, fontSize: arabicFontSize),
                  textDirection: TextDirection.rtl,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Divider(),
                ),
                const Text(
                  "حجم الخط في وضع مشاف",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Slider(
                  value: mushafFontSize,
                  min: 20,
                  max: 50,
                  onChanged: (value) {
                    setState(() {
                      mushafFontSize = value;
                    });
                  },
                ),
                Text(
                  "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                  style: TextStyle(
                      fontFamily: quranFont, fontSize: mushafFontSize),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            arabicFontSize = 28;
                            mushafFontSize = 40;
                          });
                          saveSettings();
                        },
                        child: const Text('الطبيعي')),
                    ElevatedButton(
                        onPressed: () {
                          saveSettings();
                          Navigator.of(context).pop();
                        },
                        child: const Text('حفظ')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
