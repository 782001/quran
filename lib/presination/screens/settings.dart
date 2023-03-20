import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text(
          "الاعدادات",
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
                  child: _buildTitle('حجم الخط العربي'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFFFBE8),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(
                      color: Color(0xff14697B),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Slider(
                        value: arabicFontSize,
                        min: 20,
                        max: 40,
                        activeColor: Color(0xffE95C1F),
                        thumbColor: Color(0xff14697B),
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
                      SizedBox(
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
                    color: Color(0xffFFFBE8),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    border: Border.all(
                      color: Color(0xff14697B),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Slider(
                        value: mushafFontSize,
                        min: 20,
                        max: 50,
                        activeColor: Color(0xffE95C1F),
                        thumbColor: Color(0xff14697B),
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
                      SizedBox(
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
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xff14697B),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          arabicFontSize = 28;
                          mushafFontSize = 40;
                        });
                        saveSettings();
                      },
                      child: const Text('الطبيعي'),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xff14697B),
                          ),
                        ),
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

Widget _buildTitle(String text) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xff14697B),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}
