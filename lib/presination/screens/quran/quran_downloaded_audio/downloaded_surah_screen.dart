import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran/quran_audio_screens/quran_audio_screen.dart';
import 'package:quran_v2/presination/widgets/quran_audio_service.dart';
import 'package:sizer/sizer.dart';

class DownloadedSurahScreen extends StatefulWidget {
  const DownloadedSurahScreen({Key? key}) : super(key: key);

  @override
  _DownloadedSurahScreenState createState() => _DownloadedSurahScreenState();
}

class _DownloadedSurahScreenState extends State<DownloadedSurahScreen> {
  final QuranAudioService service = QuranAudioService();
  List<Map<String, dynamic>> downloadedSurahs = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadDownloadedSurahs();
  }

  Future<void> _loadDownloadedSurahs() async {
    final surahs = await service.getAllDownloadedSurahs();
    // surahs expected format: List of maps { "suraNumber": int, "suraName": String, "reciterName": String, "path": String }
    setState(() {
      downloadedSurahs = surahs;
    });
  }

  void _filterSurahs(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = downloadedSurahs.where((surah) {
      final suraName = surah["suraName"].toString().toLowerCase();
      final reciterName = surah["reciterName"].toString().toLowerCase();
      return suraName.contains(searchQuery) ||
          reciterName.contains(searchQuery);
    }).toList();

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
          "السور المحملة",
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.06,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                onChanged: _filterSurahs,
                cursorColor: const Color(0xff592c01),
                decoration: InputDecoration(
                  hintText: "ابحث بالسورة او الشيخ...",
                  prefixIcon: const Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff592c01)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintStyle: TextStyle(
                      fontFamily: cairoFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp),
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Expanded(
              child: filtered.isNotEmpty
                  ? ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final surah = filtered[index];
                        return Card(
                          color: const Color(0xffFFFBE8),
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            title: Text(
                              surah["suraName"],
                              style: const TextStyle(
                                  fontFamily: cairoFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            subtitle: Text(
                              surah["reciterName"],
                              style: const TextStyle(
                                  fontFamily: cairoFont,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            trailing: const Icon(
                              Icons.audiotrack,
                              color: Color(0xff592c01),
                            ),
                            onTap: () {
                              NavTo(
                                context,
                                QuranAudioScreen(
                                  audioUrl: surah["path"], 
                                  SuraName: surah["suraName"],
                                  reciterName: surah["reciterName"],
                                  surahNumber: surah["suraNumber"],
                                  reciter: ReciterAudio(
                                      reciterName: surah["reciterName"],
                                      audioUrl: "",
                                      reciterId: ""),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "لا توجد سور محملة",
                        style: TextStyle(
                          fontFamily: cairoFont,
                          fontSize: context.width * 0.05,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
