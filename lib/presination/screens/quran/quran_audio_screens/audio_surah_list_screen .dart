import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran/quran_audio_screens/shukh_list_screen.dart';
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
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff592c01),
                          child: Text(
                            (surah.reciters.length + mashaikhAudio.length)
                                .toArabicNumbers
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: AutoSizeText(
                          surah.surahNameAr,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xff592c01),
                              fontWeight: FontWeight.w500,
                              fontFamily: me_quranFont),
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
}
