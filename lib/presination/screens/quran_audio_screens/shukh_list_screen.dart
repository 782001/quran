import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran_audio_screens/quran_audio_screen.dart';
import 'package:sizer/sizer.dart';

class ReciterListScreen extends StatefulWidget {
  final List<ReciterAudio> reciters;
  final String SuraName;

  const ReciterListScreen({
    super.key,
    required this.reciters,
    required this.SuraName,
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
