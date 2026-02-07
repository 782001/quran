import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran/quran_audio_screens/quran_audio_screen.dart';
import 'package:quran_v2/presination/widgets/quran_audio_service.dart';
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
    filteredReciters = widget.reciters;
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
        if (!widget.reciters
            .any((reciter) => reciter.reciterName == reciterName)) {
          widget.reciters.add(
            ReciterAudio(
              reciterId: widget.reciters.length.toString(),
              reciterName: reciterName,
              audioUrl: getAudioUrl(audioValue: reciterName, sura: sura),
            ),
          );
        }
      }
      _filterReciters(searchQuery);
    });
  }

  Future<void> _downloadReciter(ReciterAudio reciter, int suraNum) async {
    final service = QuranAudioService();
    bool downloaded = await service.isDownloaded(
        reciterName: reciter.reciterName, surahNumber: suraNum);

    if (!context.mounted) return;

    if (downloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("السورة محمّلة بالفعل"),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

    // Dialog التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ValueListenableBuilder<double>(
        valueListenable: progressNotifier,
        builder: (context, progress, _) {
          if (progress >= 1.0) {
            Future.microtask(() {
              if (context.mounted)
                Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text("تم تحميل ${reciter.reciterName} بنجاح"),
                  ),
                  backgroundColor: const Color(0xff592c01),
                  duration: const Duration(seconds: 2),
                ),
              );
              setState(() {}); // تحديث الـ icon بعد التحميل
            });
          }
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text(
                "جاري تحميل السورة",
                style: TextStyle(
                    fontFamily: cairoFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  color: const Color(0xff592c01),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 12),
                Text(
                  "${(progress * 100).toStringAsFixed(0)} %",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );

    // بدء التحميل
    await service.downloadSurah(
      url: reciter.audioUrl,
      reciterName: reciter.reciterName,
      surahNumber: suraNum,
      onProgress: (p) {
        progressNotifier.value = p;
      },
    );
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
                    borderSide: const BorderSide(color: Color(0xff592c01)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'ابحث بإسم الشيخ....',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: cairoFont,
                      fontSize: 12.sp),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredReciters.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredReciters.length,
                    itemBuilder: (context, index) {
                      final reciter = filteredReciters[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: const Color(0xffFFFBE8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          leading: const Icon(Icons.audiotrack_sharp,
                              color: Color(0xff592c01)),
                          title: AutoSizeText(
                            reciter.reciterName,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                                fontFamily: cairoFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          trailing: FutureBuilder<bool>(
                            future: QuranAudioService().isDownloaded(
                                reciterName: reciter.reciterName,
                                surahNumber: widget.suraNum),
                            builder: (context, snapshot) {
                              final downloaded = snapshot.data ?? false;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (downloaded)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  const SizedBox(width: 8),
                                  if (!downloaded)
                                    ElevatedButton(
                                      onPressed: () => _downloadReciter(
                                          reciter, widget.suraNum),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff592c01),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                      ),
                                      child: const Text(
                                        "تحميل",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: cairoFont,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          onTap: () {
                            NavTo(
                                context,
                                QuranAudioScreen(
                                  audioUrl: reciter.audioUrl,
                                  SuraName: widget.SuraName,
                                  reciterName: reciter.reciterName,
                                  reciter: reciter,
                                  surahNumber: widget.suraNum,
                                ));
                          },
                        ),
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
                  ),
          ),
        ],
      ),
    );
  }
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
