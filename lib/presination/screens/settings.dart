import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/presination/controller/app_cubit.dart';

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
        centerTitle: true,
        title: Text(
          "الاعدادات",
          style: TextStyle(
              fontFamily: quranFont,
              fontSize: arabicFontSize,
              color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color(0xffE95C1F),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: _buildTitle('حجم الخط في الوضع العادي'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFBE8),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(
                      color: const Color(0xff14697B),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Slider(
                        value: arabicFontSize,
                        min: 20,
                        max: 40,
                        activeColor: const Color(0xffE95C1F),
                        thumbColor: const Color(0xff14697B),
                        onChanged: (value) {
                          setState(() {
                            arabicFontSize = value;
                          });
                        },
                      ),
                      Text(
                        "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                        style: TextStyle(
                          fontFamily: quranFont,
                          fontSize: arabicFontSize,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Divider(),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: _buildTitle('حجم الخط في وضع المشاف'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFBE8),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(
                      color: const Color(0xff14697B),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Slider(
                        value: mushafFontSize,
                        min: 20,
                        max: 50,
                        activeColor: const Color(0xffE95C1F),
                        thumbColor: const Color(0xff14697B),
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
                        height: 12,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xff14697B),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            arabicFontSize = 28;
                            mushafFontSize = 40;
                          });
                          saveSettings();
                        },
                        child: const Text(
                          'الطبيعي',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: quranFont,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xff14697B),
                            ),
                          ),
                          onPressed: () {
                            saveSettings();
                            Navigator.of(context).pop();
                            String s = getAudioURLByVerse(114, 2);
                            print(s);
                          },
                          child: const Text(
                            'حفظ',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: quranFont,
                                color: Colors.white),
                          )),
                    ),
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

Widget _buildTitle(String text) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xff14697B),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}
