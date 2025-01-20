import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/screens/Quran_reading_HomeScreen.dart';
import 'package:quran_v2/presination/screens/quran_audio_screens/audio_surah_list_screen%20.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final data;
  @override
  @override
  Widget build(BuildContext context) {
    List<QuranModel> QuranList = [
      QuranModel(image: HomequranImage, title: " القرآن الكريم \nقراءة", id: 1),
      QuranModel(
          image: ramadanhomeImage, title: "القرآن الكريم\n استماع", id: 2),
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
            fontSize: context.width * 0.04,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: context.height * 0.05,
                ),
                // SizedBox(
                //   height: context.height * 0.05,
                // ),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xffFFFBE8),
                    ),
                    width: context.width * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: context.width * 0.01,
                          mainAxisSpacing: context.width * 0.02,
                          mainAxisExtent: context.height * 0.28,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return QuranCard(QuranList[index], data, context);
                        },
                        itemCount: QuranList.length,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget QuranCard(QuranModel model, data, BuildContext context) {
  return InkWell(
    onTap: () {
      if (model.id == 1) {
        NavTo(
            context,
            QuranHomeScreen(
              data: data,
            ));
      }
      if (model.id == 2) {
        NavTo(context, const AudioSurahListScreen());
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.width * 0.7,
          height: context.height * 0.25,
          child: Card(
            color: const Color(0xff592c01),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: context.height * 0.01,
                ),
                (model.id != 2)
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image(
                          image: AssetImage(model.image),
                          fit: BoxFit.fill,
                          width: context.width * 0.12,
                          height: context.height * 0.08,
                          color: const Color(0xfff2e3a0),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(2),
                        child: SizedBox(
                            width: context.width * 0.7,
                            height: context.height * 0.05,
                            child: const Icon(Icons.audiotrack_outlined,
                                size: 50, color: Color(0xfff2e3a0))),
                      ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xff592c01),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  width: context.width * 0.7,
                  height: context.height * 0.12,
                  child: Center(
                    child: Text(
                      model.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: cairoFont,
                        fontSize: context.width * 0.06,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class QuranModel {
  final String image;
  final String title;
  final int id;

  QuranModel({
    required this.image,
    required this.title,
    required this.id,
  });
}
