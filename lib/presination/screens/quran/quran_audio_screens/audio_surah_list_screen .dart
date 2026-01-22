import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran/quran_audio_screens/shukh_list_screen.dart';
import 'package:quran_v2/presination/widgets/quran_audio_service.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';

class AudioSurahListScreen extends StatefulWidget {
  const AudioSurahListScreen({super.key});

  @override
  _AudioSurahListScreenState createState() => _AudioSurahListScreenState();
}

class _AudioSurahListScreenState extends State<AudioSurahListScreen> {
  late Future<QuranAudioModel> quranAudioModel;
  TextEditingController searchController = TextEditingController();
  List<SurahAudio> filteredSuras = [];
  List<SurahAudio> allSuras = [];
  bool loadingDownload = false;

  @override
  void initState() {
    super.initState();
    quranAudioModel = loadQuranAudio();
  }

  Future<QuranAudioModel> loadQuranAudio() async {
    String jsonString =
        await rootBundle.loadString('assets/audio/audio_reciters.json');
    Map<String, dynamic> jsonResponse = json.decode(jsonString);
    return QuranAudioModel.fromJson(jsonResponse);
  }

  void filterSurahs(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSuras = allSuras;
      });
    } else {
      setState(() {
        filteredSuras = allSuras
            .where((surah) =>
                surah.surahNameAr.contains(query) ||
                surah.surahNameAr.contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xff592c01),
        leading: Builder(
          builder: (BuildContext context) {
            return const SizedBox.shrink();
          },
        ),
        title: Column(
          children: [
            Text(
              "القرآن الكريم\n استماع",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: cairoFont,
                fontSize: context.width * 0.06,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuranAudioModel>(
        future: quranAudioModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xff592c01),
            ));
          } else if (snapshot.hasError) {
            return const Center(child: Text('خطأ في تحميل البيانات'));
          } else if (!snapshot.hasData || snapshot.data!.suras.isEmpty) {
            return const Center(child: Text('البيانات غير متاحه'));
          } else {
            if (allSuras.isEmpty) {
              allSuras = snapshot.data!.suras;
              filteredSuras = allSuras;
            }

            return Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSurahs,
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
                        hintText: 'ابحث بإسم السورة',
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
                  child: ListView.separated(
                    itemCount: filteredSuras.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final surah = filteredSuras[index];
                      return ListTile(
                        title: const AutoSizeText(
                          "عدد الشيوخ المتاحه",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: cairoFont),
                        ),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.download,
                                  color: Color(0xff592c01)),
                              onPressed: () {
                                _showDownloadSheikhSheet(
                                  context,
                                  surah,
                                );
                              },
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xff592c01),
                              child: Text(
                                (surah.reciters.length + mashaikhAudio.length)
                                    .toArabicNumbers
                                    .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        trailing: AutoSizeText(
                          surah.surahNameAr,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xff592c01),
                            fontWeight: FontWeight.w500,
                            fontFamily: me_quranFont,
                          ),
                        ),
                        onTap: () {
                          // Navigate with a loading indicator until data is ready
                          // showDialog(
                          //   context: context,
                          //   builder: (_) => const Center(
                          //     child: CircularProgressIndicator(
                          //       color: Color(0xff592c01),
                          //     ),
                          //   ),
                          // );
                          // Load reciter details, then navigate
                          // Future.delayed(const Duration(seconds: 1), () {
                          //   Navigator.pop(context); // Dismiss loading dialog
                          NavTo(
                            context,
                            ReciterListScreen(
                              suraNum: surah.surahId,
                              reciters: surah.reciters,
                              SuraName: surah.surahNameAr,
                            ),
                          );
                          // });
                          // NavTo(
                          //     context,
                          //     ReciterListScreen(
                          //         reciters: surah.reciters,
                          //         SuraName: surah.surahNameAr));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showDownloadSheikhSheet(
    BuildContext context,
    SurahAudio surah,
  ) {
    final service = QuranAudioService();
    final reciters = mashaikhAudio.map((name) {
      return ReciterAudio(
        reciterId: name,
        reciterName: name,
        audioUrl: getAudioUrl(audioValue: name, sura: surah.surahId),
      );
    }).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 12),
              Text(
                "اختر الشيخ لتحميل السورة",
                style: TextStyle(
                    fontFamily: cairoFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff592c01)),
              ),
              const SizedBox(height: 12),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reciters.length,
                    itemBuilder: (context, index) {
                      final reciter = reciters[index];
                      return Card(
                        elevation: 3,
                        color: const Color(0xffFFFBE8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          title: Text(
                            reciter.reciterName,
                            style: const TextStyle(
                                fontFamily: cairoFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          trailing: FutureBuilder<bool>(
                            future: QuranAudioService().isDownloaded(
                                reciterName: reciter.reciterName,
                                surahNumber: surah.surahId),
                            builder: (context, snapshot) {
                              final downloaded = snapshot.data ?? false;
                              return (downloaded)
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        Navigator.pop(
                                            context); // اغلاق الـ BottomSheet

                                        bool downloaded =
                                            await service.isDownloaded(
                                          reciterName: reciter.reciterName,
                                          surahNumber: surah.surahId,
                                        );

                                        if (!context.mounted) return;

                                        if (downloaded) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Text(
                                                  "السورة محمّلة بالفعل",
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Color(0xff592c01),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );

                                          return;
                                        }

                                        // استخدام ValueNotifier للتحكم في الـ dialog
                                        ValueNotifier<double> progressNotifier =
                                            ValueNotifier(0.0);

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) =>
                                              ValueListenableBuilder<double>(
                                            valueListenable: progressNotifier,
                                            builder: (context, progress, _) {
                                              // اغلاق الـ dialog تلقائي عند 100%
                                              if (progress >= 1.0) {
                                                Future.microtask(() {
                                                  if (context.mounted) {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  }
                                                });
                                              }

                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                title: const Center(
                                                  child: Text(
                                                    "جاري تحميل السورة",
                                                    style: TextStyle(
                                                        fontFamily: cairoFont,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      value: progress,
                                                      strokeWidth: 6,
                                                      color: const Color(
                                                          0xff592c01),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    LinearProgressIndicator(
                                                      value: progress,
                                                      minHeight: 8,
                                                      color: const Color(
                                                          0xff592c01),
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      "${(progress * 100).toStringAsFixed(0)} %",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );

                                        await service.downloadSurah(
                                          url: reciter.audioUrl,
                                          reciterName: reciter.reciterName,
                                          surahNumber: surah.surahId,
                                          onProgress: (p) {
                                            progressNotifier.value =
                                                p; // تحديث الـ dialog مباشرة
                                          },
                                        );

                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "تم تحميل ${reciter.reciterName} بنجاح",
                                              style: const TextStyle(
                                                  fontFamily: cairoFont),
                                            ),
                                            backgroundColor:
                                                const Color(0xff592c01),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.download,
                                          color: Colors.white),
                                      label: const Text(
                                        "تحميل",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColors.darkBrown,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        textStyle: const TextStyle(
                                            fontFamily: cairoFont,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
