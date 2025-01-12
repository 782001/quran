
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_v2/core/shared/components.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';
import 'package:quran_v2/splash_screen.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritesList = prefs.getStringList('favoritesList') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff592c01),
        title: Text(
          "المفضله",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.04,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox.shrink(),
      ),
      body: favoritesList.isEmpty
          ? Center(
              child: Text(
                'لا توجد عناصر في المفضلة',
                style: TextStyle(
                  fontFamily: cairoFont,
                  fontSize: context.width * 0.05,
                  color: Colors.grey,
                ),
              ),
            )
          : const SingleChildScrollView(child: FavListView()),
    );
  }
}

class FavListView extends StatefulWidget {
  const FavListView({
    super.key,
  });

  @override
  _FavListViewState createState() => _FavListViewState();
}

class _FavListViewState extends State<FavListView> {
  PageController pageController = PageController();
  int CurrentIndex = 0;
  // final AudioPlayer _audioPlayer = AudioPlayer();
  Future removeFromFavorites(String text) async {
    final prefs = await SharedPreferences.getInstance();
    if (favoritesList.contains(text)) {
      setState(() {
        favoritesList.remove(text);
      });
      await prefs.setStringList('favoritesList', favoritesList);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تمت الإزالة من المفضلة',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: cairoFont),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      if (pageController.page == pageController.page!.roundToDouble()) {
        setState(() {
          CurrentIndex = pageController.page!.toInt();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.height * 0.7,
          child: PageView.builder(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              String processedNumber = (favoritesList[index] is int
                      ? favoritesList[index]
                          .toString()
                          .replaceAll(RegExp(r'\d'), '')
                      : favoritesList[index]) ??
                  "";

              CurrentIndex = index;
              return Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 50, start: 20, bottom: 20, end: 20),
                child: Container(
                  width: context.width * 0.75,
                  // height: context.height * 0.05,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color(0xffFFFBE8),
                    // color: Color(0xff592c01),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: SelectableText(
                        favoritesList[index],
                        cursorColor: const Color(0xff592c01),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // fontFamily: cairoFont,
                          fontSize: context.width * 0.05,
                          color: const Color(0xff592c01),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );

              // return ListTile(
              //   title: Text(data[index]['text']),
              // );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.all(10),
          child: Container(
            width: context.width * 0.4,
            height: context.height * 0.05,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Color(0xff592c01),
              // color: Color(0xffFFFBE8),
            ),
            child: Center(
              child: Text(
                " ${(favoritesList.length).toArabicNumbers} / ${(CurrentIndex + 1).toArabicNumbers}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: cairoFont,
                  fontSize: context.width * 0.06,
                  color: const Color(0xffFFFBE8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: context.height * .02,
        ),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: () async {
                // await _audioPlayer.play(AssetSource('audio/tap.wav'));
                setState(() {
                  CurrentIndex = pageController.page!.toInt();
                });
                print("CurrentIndex:$CurrentIndex");
                Share.share(
                    // ''' ${data[CurrentIndex] ?? ""} \n ${data[CurrentIndex]['text'] == "" ? data[CurrentIndex]['label'] : data[CurrentIndex]['text']}\n${data[CurrentIndex]['hint'] ?? ""}''');
                    favoritesList[CurrentIndex]);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff592c01)),
                child: const Center(
                    child: Icon(Icons.share, color: Color(0xffFFFBE8))),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Copy current page text to clipboard
                String text = favoritesList[CurrentIndex];
                removeFromFavorites(text).then((value) {
                  if (favoritesList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'المفضله فارغه',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: cairoFont,
                            color: Colors.white,
                          ),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    NavAndFinish(context, const SplashScreen());
                  }
                });
                // setState(() {
                //   if (favoritesList.isEmpty) {
                //     NavAndFinish(context, const SplashScreen());
                //   }
                // });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff592c01)),
                child: const Center(
                    child:
                        Icon(Icons.favorite_border, color: Color(0xffFFFBE8))),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                // Copy current page text to clipboard
                String textToCopy =
                    '''${(favoritesList[CurrentIndex] is int ? favoritesList[CurrentIndex].toString().replaceAll(RegExp(r'\d'), '') : favoritesList[CurrentIndex]) ?? ""} \n ${favoritesList[CurrentIndex] == "" ? favoritesList[CurrentIndex] : favoritesList[CurrentIndex]}\n${favoritesList[CurrentIndex] ?? ""}''';
                await Clipboard.setData(ClipboardData(text: textToCopy));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم نسخ النص',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: cairoFont,
                        color: Colors.white,
                      ),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff592c01)),
                child: const Center(
                    child: Icon(Icons.copy, color: Color(0xffFFFBE8))),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
