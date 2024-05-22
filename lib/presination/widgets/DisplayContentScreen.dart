import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';
import 'package:share_plus/share_plus.dart';

class DisplayContentScreen extends StatefulWidget {
  const DisplayContentScreen({Key? key, required this.jsonPath})
      : super(key: key);
  final String jsonPath;
  @override
  _DisplayContentScreenState createState() => _DisplayContentScreenState();
}

class _DisplayContentScreenState extends State<DisplayContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: const SizedBox.shrink(),
      ),
      body:
          SingleChildScrollView(child: JsonListView(jsonPath: widget.jsonPath)),
    );
  }
}

class JsonListView extends StatefulWidget {
  final String jsonPath;

  const JsonListView({super.key, required this.jsonPath});

  @override
  _JsonListViewState createState() => _JsonListViewState();
}

class _JsonListViewState extends State<JsonListView> {
  late Future<List<Map<String, dynamic>>> _jsonFuture;
  PageController pageController = PageController();
  int CurrentIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();

    _jsonFuture = JsonFileReader(widget.jsonPath).readJson();
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _jsonFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xff592c01),
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('عفوا اعد المحاوله لاحقا'));
        } else {
          final List<Map<String, dynamic>> data = snapshot.data!;
          return Column(
            children: [
              SizedBox(
                height: context.height * 0.55,
                child: PageView.builder(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
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
                              "${data[index]['number'] ?? ""} \n ${data[index]['text'] == "" ? data[index]['label'] : data[index]['text']}\n${data[index]['hint'] ?? ""}",
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
                      " ${(data.length).toArabicNumbers} / ${(CurrentIndex + 1).toArabicNumbers}",
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
                      await _audioPlayer.play(AssetSource('audio/tap.wav'));
                      Share.share(
                          ''' ${data[CurrentIndex]['number'] ?? ""} \n ${data[CurrentIndex]['text'] == "" ? data[CurrentIndex]['label'] : data[CurrentIndex]['text']}\n${data[CurrentIndex]['hint'] ?? ""}''');
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
                    onTap: () async {
                      await _audioPlayer.play(AssetSource('audio/tap.wav'));
                      if (pageController.page ==
                              pageController.page!.roundToDouble() &&
                          pageController.page! > 0) {
                        
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff592c01)),
                      child: const Center(
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Color(0xffFFFBE8))),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await _audioPlayer.play(AssetSource('audio/tap.wav'));

                      if (pageController.page ==
                          pageController.page!.roundToDouble()) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff592c01)),
                      child: const Center(
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              color: Color(0xffFFFBE8))),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
