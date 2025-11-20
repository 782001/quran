// ignore_for_file: prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, non_constant_identifier_names, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/main.dart';
import 'package:quran_v2/presination/widgets/sura_audio_player.dart';
import 'package:quran_v2/presination/widgets/to_arabic_no_converter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/assets_path.dart';
import '../../../../core/utils/conestans.dart';
import '../../../controller/app_cubit.dart';
import '../../../controller/app_states.dart';

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

          return SafeArea(
            child: Scaffold(
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
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: (widget.sura + 1).toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff592c01),
                              fontSize: 28.sp, // Text color
                              fontFamily: arFont),
                        ),
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
      required this.sura,
      required this.previousVerses,
      required this.arabic});
  final int index;
  final int sura;
  final int previousVerses;
  final arabic;
  @override
  Widget build(BuildContext context) {
    String fixedAyaText = "";
    if (arabic[index + previousVerses]['sura_no'] == 7 &&
        arabic[index + previousVerses]['aya_no'] == 46) {
      fixedAyaText =
          "${quran.getVerse(7, 46, verseEndSymbol: false)}\ufd3f${46.toString().toArabicNumbers}\ufd3e";
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                arabic[index + previousVerses]['sura_no'] == 7 &&
                        arabic[index + previousVerses]['aya_no'] == 46
                    ? fixedAyaText
                    : arabic[index + previousVerses]['aya_text'],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: arabic[index + previousVerses]['sura_no'] == 7 &&
                          arabic[index + previousVerses]['aya_no'] == 46
                      ? mushafFontSize - 10
                      : mushafFontSize,
                  fontFamily: arabic[index + previousVerses]['sura_no'] == 7 &&
                          arabic[index + previousVerses]['aya_no'] == 46
                      ? me_quranFont
                      : arabicFont,
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
  int ayahindex = 0;

  @override
  State<SingleSuraBuilder> createState() => _SingleSuraBuildeState();
}

class _SingleSuraBuildeState extends State<SingleSuraBuilder> {
  late AudioPlayer _audioPlayer = AudioService.instance;
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
  String? audioUrl;
  String tafserText = "";
  Future<void> playAyaAudio(int suraNumper, int verseIndex) async {
    audioUrl = getAudioURLByVerse(suraNumper, verseIndex, "ar.minshawi") ?? "";
    log(audioUrl ?? "");
    // _audioPlayer = AudioPlayer()..setUrl(audioUrl);
    Uri assetUri = await getAssetUri('assets/images/quran.png');
    await _audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(audioUrl ?? ""),
      tag: MediaItem(
          playable: true,
          id: '1',
          album: widget.suraName,
          title: "آية رقم $verseIndex",
          artUri: assetUri),
    ));
    _audioPlayer.positionStream;
    _audioPlayer.bufferedPositionStream;
    _audioPlayer.durationStream;
    // _audioPlayer.play;
  }

  Future<void> loadTafseerData() async {
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

  @override
  void initState() {
    super.initState();
    // getConnectivity();
    _audioPlayer = AudioPlayer();
    // _quranVerses = Quran.getVerses();
    loadTafseerData();
    // Listen for changes in the currently visible item
    itemPositionsListener.itemPositions.addListener(_onItemPositionChanged);
  }

  void _onItemPositionChanged() {
    if (!mounted) return; // Prevent setState after dispose
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      int firstVisibleIndex = positions
          .where((pos) => pos.itemLeadingEdge >= 0)
          .map((pos) => pos.index)
          .reduce((min, index) => index); // Get the first visible item

      setState(() {
        widget.ayahindex = firstVisibleIndex;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    itemPositionsListener.itemPositions
        .removeListener(_onItemPositionChanged); // Remove listener

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
    // log(
    //   "sura Num:  ${widget.sura}   | aya Num:     ${widget.arabic[widget.ayahindex + previousVerses]["aya_no"]}",
    // );
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: const Color.fromARGB(255, 253, 251, 240),
                  child: widget.view
                      ? ScrollablePositionedList.builder(
                          itemBuilder: (BuildContext context, int index) {
                            // setState(() {
                            // widget.ayahindex = index;
                            // });
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
                                        ? const Color.fromARGB(
                                            255, 253, 251, 240)
                                        : const Color.fromARGB(
                                            255, 253, 247, 230),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                  ),
                                  child: PopupMenuButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: verseBuilder(
                                          index: index,
                                          sura: widget.sura,
                                          previousVerses: previousVerses,
                                          arabic: arabic,
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () async {
                                                log("${widget.sura + 1}");
                                                log("${arabic[index + previousVerses]['aya_no']}");

                                                String textToCopy = getVerse(
                                                    widget.sura + 1,
                                                    arabic[index +
                                                            previousVerses]
                                                        ['aya_no'],
                                                    verseEndSymbol: true);
                                                log(textToCopy);
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: textToCopy));
                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(
                                                //   const SnackBar(
                                                //     content: Text(
                                                //       'تم نسخ النص',
                                                //       textAlign: TextAlign.center,
                                                //       style: TextStyle(
                                                //         fontFamily: cairoFont,
                                                //         color: Colors.white,
                                                //       ),
                                                //     ),
                                                //     duration: Duration(seconds: 2),
                                                //   ),
                                                // );
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
                                                saveBookMark(
                                                    widget.sura + 1, index);
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
                                                      state:
                                                          ToustStates.SUCSESS);
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
                                                final tafseerText =
                                                    getTafseerText(
                                                        widget.sura + 1,
                                                        index + 1);

                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: AlertDialog(
                                                      title: Text(
                                                        'تفسير  الآيه',
                                                        style: TextStyle(
                                                          fontFamily: cairoFont,
                                                          fontSize:
                                                              context.width *
                                                                  0.06,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                          tafseerText,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  cairoFont,
                                                              fontSize: context
                                                                      .width *
                                                                  0.04,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              height: 2.5),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          const Color(
                                                              0xff592c01),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      widget.sura + 1 != 1 &&
                                              widget.sura + 1 != 9
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
                                            fontFamily: "Taha",
                                            color: const Color.fromARGB(
                                                196, 44, 44, 44),
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
                audioUrl?.contains("https://cdn.islamic.") ?? false
                    ? Positioned(
                        bottom: 1,
                        right: 0,
                        left: 0,
                        child: Controls(
                          audioPlayer: _audioPlayer,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.black),
              child: Center(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "الجزء ${getArabicOrdinal(widget.arabic[widget.ayahindex + previousVerses]["jozz"])}   |   الحزب ${getArabicOrdinal(QuranData.getHizbAndQuarter(widget.sura + 1, widget.arabic[widget.ayahindex + previousVerses]["aya_no"])['hizb'])}  |  الربع ${getArabicOrdinal(QuranData.getHizbAndQuarter(widget.sura + 1, widget.arabic[widget.ayahindex + previousVerses]["aya_no"])['quarter'])}",
                    style: TextStyle(
                      color: AppColors.DefaultColor,
                      fontFamily: cairoFont,
                    ),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

String getArabicOrdinal(dynamic text) {
  if (text == null) return "";
  int number = int.tryParse(text.toString()) ?? 0;
  return (number > 0 && number < arabicOrdinals.length)
      ? arabicOrdinals[number]
      : text.toString();
}

List<String> arabicOrdinals = [
  "",
  "الأول",
  "الثاني",
  "الثالث",
  "الرابع",
  "الخامس",
  "السادس",
  "السابع",
  "الثامن",
  "التاسع",
  "العاشر",
  "الحادي عشر",
  "الثاني عشر",
  "الثالث عشر",
  "الرابع عشر",
  "الخامس عشر",
  "السادس عشر",
  "السابع عشر",
  "الثامن عشر",
  "التاسع عشر",
  "العشرون",
  "الحادي والعشرون",
  "الثاني والعشرون",
  "الثالث والعشرون",
  "الرابع والعشرون",
  "الخامس والعشرون",
  "السادس والعشرون",
  "السابع والعشرون",
  "الثامن والعشرون",
  "التاسع والعشرون",
  "الثلاثون",
  "الحادي والثلاثون",
  "الثاني والثلاثون",
  "الثالث والثلاثون",
  "الرابع والثلاثون",
  "الخامس والثلاثون",
  "السادس والثلاثون",
  "السابع والثلاثون",
  "الثامن والثلاثون",
  "التاسع والثلاثون",
  "الأربعون",
  "الحادي والأربعون",
  "الثاني والأربعون",
  "الثالث والأربعون",
  "الرابع والأربعون",
  "الخامس والأربعون",
  "السادس والأربعون",
  "السابع والأربعون",
  "الثامن والأربعون",
  "التاسع والأربعون",
  "الخمسون",
  "الحادي والخمسون",
  "الثاني والخمسون",
  "الثالث والخمسون",
  "الرابع والخمسون",
  "الخامس والخمسون",
  "السادس والخمسون",
  "السابع والخمسون",
  "الثامن والخمسون",
  "التاسع والخمسون",
  "الستون"
];

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
                    backgroundColor: WidgetStateProperty.all(
                      const Color(0xff592c01),
                    ),
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    elevation: WidgetStateProperty.resolveWith<double>(
                      (Set<WidgetState> states) {
                        // if the button is pressed the elevation is 10.0, if not
                        // it is 5.0
                        if (states.contains(WidgetState.pressed)) {
                          return 10.0;
                        }
                        return 0;
                      },
                    ),
                    // textColor: Colors.white,
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                    backgroundColor: WidgetStateProperty.all(
                      const Color(0xff592c01),
                    ),
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    elevation: WidgetStateProperty.resolveWith<double>(
                      (Set<WidgetState> states) {
                        // if the button is pressed the elevation is 10.0, if not
                        // it is 5.0
                        if (states.contains(WidgetState.pressed)) {
                          return 10.0;
                        }
                        return 0;
                      },
                    ),
                    // textColor: Colors.white,
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
      height: 70,
      width: size.width,
    );
  }
}

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static AudioPlayer get instance => _player;
}
