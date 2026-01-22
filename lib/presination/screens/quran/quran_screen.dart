import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/screens/quran/quran_audio_screens/audio_surah_list_screen%20.dart';
import 'package:quran_v2/presination/screens/quran/quran_downloaded_audio/downloaded_surah_screen.dart';
import 'package:quran_v2/presination/screens/quran/quran_reading/Quran_reading_HomeScreen.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  Widget build(BuildContext context) {
    List<QuranModel> QuranList = [
      QuranModel(image: HomequranImage, title: "القرآن الكريم\nقراءة", id: 1),
      QuranModel(
          image: ramadanhomeImage, title: "القرآن الكريم\nاستماع", id: 2),
      QuranModel(
          image: ramadanhomeImage,
          title: "السور المحمّلة\nالاستماع من الجهاز",
          id: 3),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffFFFBE8),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const SizedBox.shrink();
          },
        ),
        backgroundColor: const Color(0xff592c01),
        title: Text(
          "بَلْ هُوَ قُرْآنٌ مَجِيدٌ فِي لَوْحٍ مَحْفُوظٍ",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: quranFont,
            fontSize: context.width * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: context.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: QuranCard(QuranList[1], data, context)),
                SizedBox(width: context.width * 0.04),
                Expanded(child: QuranCard(QuranList[0], data, context)),
              ],
            ),
            SizedBox(height: context.height * 0.03),
            // الصف الثاني: كرت واحد كامل العرض
            QuranCard(QuranList[2], data, context, fullWidth: true),
          ],
        ),
      ),
    );
  }
}

Widget QuranCard(QuranModel model, data, BuildContext context,
    {bool fullWidth = false}) {
  Color cardColor;
  IconData cardIcon;

  switch (model.id) {
    case 1:
      cardColor = const Color(0xff6D4C41);
      cardIcon = Icons.menu_book;
      break;
    case 2:
      cardColor = MyColors.babyBrown;
      cardIcon = Icons.audiotrack;

      break;

    case 3:
      cardColor = MyColors.darkBrown;
      cardIcon = Icons.download_done;
      break;
    default:
      cardColor = const Color(0xffA1887F);
      cardIcon = Icons.book;
  }

  return InkWell(
    onTap: () {
      switch (model.id) {
        case 1:
          NavTo(context, QuranHomeScreen(data: data));
          break;
        case 2:
          NavTo(context, const AudioSurahListScreen());
          break;
        case 3:
          NavTo(context, const DownloadedSurahScreen());
          break;
      }
    },
    child: Card(
      elevation: 5,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: context.height * 0.22,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(cardIcon, size: 35, color: cardColor),
            ),
            SizedBox(height: context.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                model.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: cairoFont,
                  fontSize: context.width * 0.045,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class QuranModel {
  final String image;
  final String title;
  final int id;

  QuranModel({required this.image, required this.title, required this.id});
}
