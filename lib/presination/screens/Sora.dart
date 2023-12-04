import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/presination/screens/surah_builder.dart';

import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../surah_model.dart';
import '../widgets/arabic_sura_num.dart';

class SurahPage extends StatefulWidget {
  final Surah surah;
  final sura;
  const SurahPage({Key? key, required this.surah, required this.sura})
      : super(key: key);

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  int mark = 0;

  @override
  Widget build(BuildContext context) {
    int count = widget.surah.versesCount;
    int index = widget.surah.id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: const Color(0xff14697B),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => Settings()));
        //       },
        //       icon: Icon(
        //         Icons.settings,
        //       )),
        // ],
        // leading: Tooltip(
        //   message: 'مشاف',
        //   child: TextButton(
        //     child: const Icon(
        //       Icons.chrome_reader_mode,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       cubit.ChangeView();

        //       // setState(() {
        //       //   view = !view;
        //       // });
        //     },
        //   ),
        // ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        flexibleSpace: Stack(
          children: [
            const Background(),
            Positioned(
              top: 30,
              // bottom: 5,
              left: 5,
              right: 5,
              child: Text(
                //
                widget.surah.arabicName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: me_quranFont,
                    shadows: const [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(2),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 253, 251, 240),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(
              color: const Color(0xffE95C1F),
              width: 7,
            ),
          ),
          child: ListView(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: widget.sura + 1 != 1 && widget.sura + 1 != 9
                    ? header()
                    : const Text(''),

                // (index != 0) || (sura == 0) || (sura == 8)
                //     ? const Text('')
                //     : ReturnBasmala(),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              textAlign: count <= 20 ? TextAlign.center : TextAlign.justify,
              text: TextSpan(
                children: [
                  for (var i = 1; i <= count; i++) ...{
                    TextSpan(
                      text:
                          ' ${quran.getVerse(index, i, verseEndSymbol: false)} ',
                      style: TextStyle(
                        fontFamily: quranFont,
                        fontSize: arabicFontSize,
                        fontWeight: FontWeight.w200,
                        color: Colors.black87,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: ArabicSuraNumber(
                          i: i - 1,
                        ),
                      ),
                      // InkWell(
                      //     onTap: () {
                      //       debugPrint(i.toString());
                      //     },
                      //     child: Stack(
                      //       alignment: AlignmentDirectional.center,
                      //       children: [
                      //         Container(
                      //           height: fontSize,
                      //           width: fontSize,
                      //           clipBehavior: Clip.none,
                      //           child: Image.asset(
                      //             "assets/101.png",
                      //             color: mark == i
                      //                 ? Colors.orange
                      //                 : Colors.black,
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //         Text(
                      //           arabicNumber.convert(i),
                      //           // '${i.c}',
                      //           textAlign: TextAlign.center,
                      //           textScaleFactor:
                      //               i.toString().length <= 2 ? 1 : .8,
                      //         ),
                      //       ],
                      //     )))
                    )
                  }
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget header() {
    return Text(
      ' ${quran.basmala} ',
      textDirection: TextDirection.rtl,
      style: TextStyle(
          fontFamily: quranFont,
          fontSize: arabicFontSize,
          fontWeight: FontWeight.w700),
    );
  }
}
