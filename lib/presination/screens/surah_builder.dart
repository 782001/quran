// ignore_for_file: prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../controller/app_cubit.dart';
import '../controller/app_states.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SurahBuilder extends StatefulWidget {
  final sura;
  final arabic;
  final suraName;
  int ayah;

  SurahBuilder(
      {Key? key, this.sura, this.arabic, this.suraName, required this.ayah})
      : super(key: key);

  @override
  State<SurahBuilder> createState() => _SurahBuilderState();
}

class _SurahBuilderState extends State<SurahBuilder> {
  @override
  Widget build(BuildContext context) {
    int LengthOfSura = noOfVerses[widget.sura];
    return BlocProvider(
      create: (context) => AppCubit()..initState(widget.ayah),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          var view = AppCubit.get(context).view;

          return Scaffold(
            appBar: AppBar(
              // backgroundColor: const Color(0xff14697B),
              // actions: [
              //   IconButton(
              //       onPressed: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => Settings()));
              //       },
              //       icon: Icon(
              //         Icons.settings,
              //       )),
              // ],
              // leading: Tooltip(
              //   message: 'مشاف',
              //   child: TextButton(
              //     child: const Icon(
              //       Icons.chrome_reader_mode,
              //       color: Colors.white,
              //     ),
              //     onPressed: () {
              //       cubit.ChangeView();

              //       // setState(() {
              //       //   view = !view;
              //       // });
              //     },
              //   ),
              // ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              flexibleSpace: Stack(
                children: [
                  const Background(),
                  Positioned(
                    top: context.height * .03,
                    left: context.width * .01,
                    right: context.width * .01,
                    child: Text(
                      //
                      widget.suraName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff592c01),
                          fontFamily: me_quranFont,
                          shadows: const [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleSuraBuilder(
              view: view,
              sura: widget.sura,
              arabic: widget.arabic,
              LenghtOfSura: LengthOfSura,
              suraName: widget.suraName,
            ),
          );
        },
      ),
    );
  }
}

class verseBuilder extends StatelessWidget {
  const verseBuilder(
      {super.key,
      required this.index,
      required this.previousVerses,
      required this.arabic});
  final int index;
  final previousVerses;
  final arabic;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                arabic[index + previousVerses]['aya_text'],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: mushafFontSize,
                  fontFamily: arabicFont,
                  color: const Color.fromARGB(196, 0, 0, 0),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// Row verseBuilder(int index, previousVerses) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 widget.arabic[index + previousVerses]['aya_text'],
//                 textDirection: TextDirection.rtl,
//                 style: TextStyle(
//                   fontSize: mushafFontSize,
//                   fontFamily: arabicFont,
//                   color: const Color.fromARGB(196, 0, 0, 0),
//                 ),
//               ),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

class SingleSuraBuilder extends StatefulWidget {
  SingleSuraBuilder(
      {super.key,
      required this.sura,
      required this.arabic,
      required this.suraName,
      required this.LenghtOfSura,
      required this.view});
  final sura;
  final arabic;
  final suraName;
  final LenghtOfSura;
  final view;
  int? ayah;

  @override
  State<SingleSuraBuilder> createState() => _SingleSuraBuildeState();
}

class _SingleSuraBuildeState extends State<SingleSuraBuilder> {
  late AudioPlayer _audioPlayer;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  List<dynamic> tafseerData = [];

  Stream<PossitionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PossitionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PossitionData(
              position, bufferedPosition, duration ?? Duration.zero));
  String audioUrl = "";
  String tafserText = "";
  void playAyaAudio(int suraNumper, int verseIndex) {
    audioUrl = getAudioURLByVerse(suraNumper, verseIndex, "ar.minshawi");
    print(audioUrl);
    _audioPlayer = AudioPlayer()..setUrl(audioUrl);
    _audioPlayer.positionStream;
    _audioPlayer.bufferedPositionStream;
    _audioPlayer.durationStream;
    // _audioPlayer.play;
  }

  Future<void> loadTafseerData() async {
    // Map<dynamic, dynamic> ayaTexts = searchWords("الله الذي");
    // log("${ayaTexts["result"]}");

    // Map<dynamic, dynamic> ayaaTexts = searchWords(["بسم"]);
    // log("$ayaaTexts");
    // Map<dynamic, dynamic> ayaaaTexts = searchWords(["وهي تجري"]);
    // log("$ayaaaTexts");

    final String response = await rootBundle.loadString('assets/tafseer.json');
    setState(() {
      tafseerData = jsonDecode(response);
    });
  }

  String getTafseerText(int surahNumber, int ayaNumber) {
    final tafseer = tafseerData.firstWhere(
      (element) =>
          element['number'] == surahNumber.toString() &&
          element['aya'] == ayaNumber.toString(),
      orElse: () => null,
    );
    return tafseer != null ? tafseer['text'] : 'تفسير  الآيه عير متاح';
  }

  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen(
  //       (ConnectivityResult result) async {
  //         isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //         if (!isDeviceConnected && isAlertSet == false) {
  //           showDialogBox();
  //           setState(() {
  //             isAlertSet = true;
  //           });
  //         }
  //       },
  //     );
  @override
  void initState() {
    super.initState();
    // getConnectivity();
    _audioPlayer = AudioPlayer();
    // _quranVerses = Quran.getVerses();
    loadTafseerData();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fullSura = '';
    int previousVerses = 0;
    if (widget.sura + 1 != 1) {
      for (int i = widget.sura - 1; i >= 0; i--) {
        previousVerses = previousVerses + noOfVerses[i];
      }
    }

    if (!widget.view)
      for (int i = 0; i < widget.LenghtOfSura; i++) {
        fullSura += (widget.arabic[i + previousVerses]['aya_text']);
      }

    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 253, 251, 240),
            child: widget.view
                ? ScrollablePositionedList.builder(
                    itemBuilder: (BuildContext context, int index) {
                      // void playAyaAudio(int suraNumper, int verseIndex) {
                      //   // Assuming that you have audio files corresponding to each ayah
                      //   // and they are named in a way that corresponds to their verse numbers.
                      //   // String audioPath = 'assets/audio/${verse.surahNumber}_${verse.ayahNumber}.mp3';
                      //   String audioUrl =
                      //       getAudioURLByVerse(suraNumper, verseIndex);
                      //   print(audioUrl);
                      //   widget._audioPlayer.play(UrlSource(audioUrl));
                      // }

                      return Column(
                        children: [
                          (index != 0) ||
                                  (widget.sura == 0) ||
                                  (widget.sura == 8)
                              ? const Text('')
                              : const ReturnBasmala(),
                          Container(
                            decoration: BoxDecoration(
                              color: index % 2 != 0
                                  ? const Color.fromARGB(255, 253, 251, 240)
                                  : const Color.fromARGB(255, 253, 247, 230),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                            ),
                            child: PopupMenuButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: verseBuilder(
                                    index: index,
                                    previousVerses: previousVerses,
                                    arabic: arabic,
                                  ),
                                ),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () async {
                                          log("${widget.sura + 1}");
                                          log("${index + previousVerses + 1}");
                                          String textToCopy = getVerse(
                                              widget.sura + 1,
                                              index + previousVerses + 1,
                                              verseEndSymbol: false);
                                          log(textToCopy);
                                          await Clipboard.setData(
                                              ClipboardData(text: textToCopy));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.copy,
                                              color: Color(0xff592c01),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("نسخ النص"),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          saveBookMark(widget.sura + 1, index);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.bookmark_add,
                                              color: Color(0xff592c01),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('احفظ الآيه'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () async {
                                          playAyaAudio(
                                              widget.sura + 1, index + 1);
                                          isDeviceConnected =
                                              await InternetConnectionChecker()
                                                  .hasConnection;
                                          if (!isDeviceConnected &&
                                              isAlertSet == false) {
                                            ShowToust(
                                                Text: "لا يوجد انترنت",
                                                state: ToustStates.SUCSESS);
                                            setState(() {
                                              isAlertSet = true;
                                            });
                                          }
                                          setState(() {
                                            // _audioPlayer.play;
                                          });
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.audiotrack_rounded,
                                              color: Color(0xff592c01),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('استمع الي الآيه'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () async {
                                          final tafseerText = getTafseerText(
                                              widget.sura + 1, index + 1);

                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: AlertDialog(
                                                title: Text(
                                                  'تفسير  الآيه',
                                                  style: TextStyle(
                                                    fontFamily: cairoFont,
                                                    fontSize:
                                                        context.width * 0.06,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Text(
                                                    tafseerText,
                                                    style: TextStyle(
                                                        fontFamily: cairoFont,
                                                        fontSize:
                                                            context.width *
                                                                0.04,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        height: 2.5),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    const Color(0xff592c01),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.comment,
                                              color: Color(0xff592c01),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('تفسير  الآيه'),
                                          ],
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      );
                    },
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemCount: widget.LenghtOfSura,
                  )
                : ListView(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.sura + 1 != 1 && widget.sura + 1 != 9
                                    ? const ReturnBasmala()
                                    : const Text(''),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    fullSura, //mushaf mode
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: mushafFontSize,
                                      fontFamily: arabicFont,
                                      color:
                                          const Color.fromARGB(196, 44, 44, 44),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          audioUrl.contains("https://cdn.islamic.")
              ? Positioned(
                  bottom: 1,
                  right: 0,
                  left: 0,
                  child: Controls(
                    audioPlayer: _audioPlayer,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}


class ReturnBasmala extends StatelessWidget {
  const ReturnBasmala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Text(
          "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
          style: TextStyle(fontFamily: quranFont, fontSize: mushafFontSize),
          textDirection: TextDirection.rtl,
        ),
      ),
    ]);
  }
}

class PossitionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PossitionData(this.position, this.bufferedPosition, this.duration);
}

class Controls extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const Controls({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;

        if (!(playing ?? false)) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: context.width * 1,
              height: context.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff592c01),
              ),
              // ignore: dead_code
              child: ElevatedButton(
                  style: ButtonStyle(
                    //padding: EdgeInsets.all(10.0),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xff592c01),
                    ),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        // if the button is pressed the elevation is 10.0, if not
                        // it is 5.0
                        if (states.contains(MaterialState.pressed)) {
                          return 10.0;
                        }
                        return 0;
                      },
                    ),
                    // textColor: Colors.white,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: const BorderSide(
                        //     color: Color(0xff04685C), width: 2),
                      ),
                    ),
                  ),
                  onPressed: audioPlayer.play,
                  child: const Text(
                    'استمع',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: quranFont,
                        color: Colors.white),
                  )),
            ),
          );
        } else if (processingState != ProcessingState.completed) {
          return const SizedBox();
        } else if (processingState != ProcessingState.loading) {
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: context.width * 1,
              height: context.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff592c01),
              ),
              // ignore: dead_code
              child: ElevatedButton(
                  style: ButtonStyle(
                    //padding: EdgeInsets.all(10.0),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xff592c01),
                    ),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        // if the button is pressed the elevation is 10.0, if not
                        // it is 5.0
                        if (states.contains(MaterialState.pressed)) {
                          return 10.0;
                        }
                        return 0;
                      },
                    ),
                    // textColor: Colors.white,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: const BorderSide(
                        //     color: Color(0xff04685C), width: 2),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const CircularProgressIndicator()),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Image.asset(
      'assets/images/suraBackground.jpg',
      fit: BoxFit.fill,
      height: 100,
      width: size.width,
    );
  }
}
