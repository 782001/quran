import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran/quran_audio_screens/quran_audio_screen.dart';
import 'package:sizer/sizer.dart';

class ReciterListScreen extends StatefulWidget {
  final List<ReciterAudio> reciters;
  final String SuraName;
  final int suraNum;

  const ReciterListScreen({
    super.key,
    required this.reciters,
    required this.SuraName,
    required this.suraNum,
  });

  @override
  _ReciterListScreenState createState() => _ReciterListScreenState();
}

class _ReciterListScreenState extends State<ReciterListScreen> {
  late List<ReciterAudio> filteredReciters;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredReciters = widget.reciters; // Initialize with the full list
    addPredefinedReciters(widget.suraNum);
  }

  void _filterReciters(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredReciters = widget.reciters
          .where((reciter) =>
              reciter.reciterName.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void addPredefinedReciters(int sura) {
    setState(() {
      for (var reciterName in mashaikhAudio) {
        // Check if reciter is already in the list
        if (!widget.reciters
            .any((reciter) => reciter.reciterName == reciterName)) {
          widget.reciters.add(
            ReciterAudio(
              reciterId:
                  widget.reciters.length.toString(), // Generate unique ID
              reciterName: reciterName,
              audioUrl: getAudioUrl(audioValue: reciterName, sura: sura),
            ),
          );
        }
      }
      _filterReciters(searchQuery); // Refresh filtered list
    });
  }

  String getAudioUrl({required String audioValue, required int sura}) {
    String suraNum = sura.toString();
    if (sura < 10) {
      suraNum = "00$sura";
    } else if (sura > 10 && sura < 100) {
      suraNum = "0$sura";
    } else {
      suraNum = "$sura";
    }
    switch (audioValue) {
      case "محمد صديق المنشاوي - مجود":
        return "https://server10.mp3quran.net/minsh/Almusshaf-Al-Mojawwad/$suraNum.mp3";
      case "محمد صديق المنشاوي - مرتل":
        return "https://server10.mp3quran.net/minsh/$suraNum.mp3";
      case "الحصري - مجود":
        return "https://server13.mp3quran.net/husr/Almusshaf-Al-Mojawwad/$suraNum.mp3";
      case "الحصري - مرتل":
        return "https://server13.mp3quran.net/husr/Rewayat-Qalon-A-n-Nafi/$suraNum.mp3";
      case "عبدالباسط عبدالصمد - مجود":
        return "https://server7.mp3quran.net/basit/Almusshaf-Al-Mojawwad/$suraNum.mp3";
      case "عبدالباسط عبدالصمد - مرتل":
        return "https://server7.mp3quran.net/basit/$suraNum.mp3";
      case "محمود علي البنا - مجود":
        return "https://server8.mp3quran.net/bna/Almusshaf-Al-Mojawwad/$suraNum.mp3";
      case "محمود علي البنا - مرتل":
        return "https://server8.mp3quran.net/bna/$suraNum.mp3";
      case "مصطفى إسماعيل":
        return "https://server8.mp3quran.net/mustafa/Almusshaf-Al-Mojawwad/$suraNum.mp3";
      case "محمد جبريل":
        return "https://server8.mp3quran.net/jbrl/$suraNum.mp3";
      case "محمد أيوب":
        return "https://server16.mp3quran.net/ayyoub2/Rewayat-Hafs-A-n-Assem/$suraNum.mp3";
      case "مشاري راشد العفاسي":
        return "https://server8.mp3quran.net/afs/$suraNum.mp3";
      case "ماهر المعيقلي - مجود":
        return "https://server12.mp3quran.net/maher/Almusshaf-Al-Mojawwad/$suraNum.mp3";
      case "ماهر المعيقلي - مرتل":
        return "https://server12.mp3quran.net/maher/$suraNum.mp3";
      case "سعود الشريم":
        return "https://server7.mp3quran.net/shur/$suraNum.mp3";
      case "ناصر القطامي":
        return "https://server6.mp3quran.net/qtm/$suraNum.mp3";
      case "سعد الغامدي":
        return "https://server7.mp3quran.net/s_gmd/$suraNum.mp3";
      case "عبد الرحمن السديس":
        return "https://server11.mp3quran.net/sds/$suraNum.mp3";
      case "صلاح بو خاطر":
        return "https://server8.mp3quran.net/bu_khtr/$suraNum.mp3";
      case "عبدالرشيد صوفي":
        return "https://server16.mp3quran.net/soufi/Rewayat-Hafs-A-n-Assem/$suraNum.mp3";
      case "علي بن عبدالرحمن الحذيفي":
        return "https://server9.mp3quran.net/hthfi/Rewayat-Sho-bah-A-n-Asim/$suraNum.mp3";
      case "علي جابر":
        return "https://server11.mp3quran.net/a_jbr/$suraNum.mp3";
      case "فارس عباد":
        return "https://server8.mp3quran.net/frs_a/$suraNum.mp3";
      case "منصور السالمي":
        return "https://server14.mp3quran.net/mansor/$suraNum.mp3";
      case "حسن صالح":
        return "https://server16.mp3quran.net/h_saleh/Rewayat-Hafs-A-n-Assem/$suraNum.mp3";
      case "ياسر الدوسري":
        return "https://server11.mp3quran.net/yasser/$suraNum.mp3";
      default:
        return ""; // return an empty string or null for unknown reciters
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const SizedBox.shrink();
          },
        ),
        backgroundColor: const Color(0xff592c01),
        title: AutoSizeText(
          'الشيوخ المتاحه',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.06,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _filterReciters,
                cursorColor: const Color(0xff592c01),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff592c01),
                    ),
                    gapPadding: 5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintStyle: TextStyle(
                      // color: const Color(0xff592c01),

                      fontWeight: FontWeight.bold,
                      fontFamily: cairoFont,
                      fontSize: 12.sp),
                  hintText: 'ابحث بإسم الشيخ....',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: filteredReciters.isNotEmpty
                  ? ListView.separated(
                      itemCount: filteredReciters.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final reciter = filteredReciters[index];
                        return ListTile(
                          subtitle: AutoSizeText(
                            reciter.reciterName,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: cairoFont,
                            ),
                          ),
                          leading: const Icon(
                            Icons.audiotrack_sharp,
                            color: Color(0xff592c01),
                          ),
                          onTap: () {
                            NavTo(
                              context,
                              QuranAudioScreen(
                                audioUrl: reciter.audioUrl,
                                SuraName: widget.SuraName,
                                reciterName: reciter.reciterName,
                              ),
                            );
                            log("Audio URL: ${reciter.audioUrl}");
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: TextStyle(
                          fontFamily: cairoFont,
                          fontSize: context.width * 0.05,
                          color: Colors.grey,
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}

List<String> mashaikhAudio = [
  "محمد صديق المنشاوي - مجود",
  "محمد صديق المنشاوي - مرتل",
  "الحصري - مجود",
  "الحصري - مرتل",
  "عبدالباسط عبدالصمد - مجود",
  "عبدالباسط عبدالصمد - مرتل",
  "محمود علي البنا - مجود",
  "محمود علي البنا - مرتل",
  "مصطفى إسماعيل",
  "محمد جبريل",
  "علي بن عبدالرحمن الحذيفي",
  "علي جابر",
  "ياسر الدوسري",
  "محمد أيوب",
  "مشاري راشد العفاسي",
  "حسن صالح",
  "ماهر المعيقلي - مجود",
  "ماهر المعيقلي - مرتل",
  "سعود الشريم",
  "فارس عباد",
  "ناصر القطامي",
  "منصور السالمي",
  "عبدالرشيد صوفي",
  "سعد الغامدي",
  "عبد الرحمن السديس",
  "صلاح بو خاطر",
];
