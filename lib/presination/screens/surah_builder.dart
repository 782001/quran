// ignore_for_file: prefer_typing_uninitialized_variables, curly_braces_in_flow_control_structures, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/utils/assets_path.dart';
import '../../core/utils/conestans.dart';
import '../controller/app_cubit.dart';
import '../controller/app_states.dart';

// class SurahBuilder extends StatefulWidget {
//   final sura;
//   final arabic;
//   final suraName;
//   int ayah;

//   SurahBuilder(
//       {Key? key, this.sura, this.arabic, this.suraName, required this.ayah})
//       : super(key: key);

//   @override
//   _SurahBuilderState createState() => _SurahBuilderState();
// }

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
                    top: 30,
                    // bottom: 5,
                    left: 5,
                    right: 5,
                    child: Text(
                      //
                      widget.suraName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
  Stream<PossitionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PossitionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PossitionData(
              position, bufferedPosition, duration ?? Duration.zero));
  String audioUrl = "";
  void playAyaAudio(int suraNumper, int verseIndex) {
    audioUrl = getAudioURLByVerse(suraNumper, verseIndex);
    print(audioUrl);
    _audioPlayer = AudioPlayer()..setUrl(audioUrl);
    _audioPlayer.positionStream;
    _audioPlayer.bufferedPositionStream;
    _audioPlayer.durationStream;
    // _audioPlayer.play;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // _quranVerses = Quran.getVerses();
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
                                        onTap: () {
                                          saveBookMark(widget.sura + 1, index);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.bookmark_add,
                                              color: Color.fromARGB(
                                                  255, 56, 115, 59),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('احفظ الآيه'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          playAyaAudio(
                                              widget.sura + 1, index + 1);
                                          setState(() {
                                            // _audioPlayer.play;
                                          });
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.audiotrack_rounded,
                                              color: Color.fromARGB(
                                                  255, 56, 115, 59),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('استمع الي الآيه'),
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

// SafeArea SingleSuraBuilder(LenghtOfSura, view) {
//   String fullSura = '';
//   int previousVerses = 0;
//   if (widget.sura + 1 != 1) {
//     for (int i = widget.sura - 1; i >= 0; i--) {
//       previousVerses = previousVerses + noOfVerses[i];
//     }
//   }

//   if (!view)
//     for (int i = 0; i < LenghtOfSura; i++) {
//       fullSura += (widget.arabic[i + previousVerses]['aya_text']);
//     }
//   return SafeArea(
//     child: Container(
//       color: const Color.fromARGB(255, 253, 251, 240),
//       child: view
//           ? ScrollablePositionedList.builder(
//               itemBuilder: (BuildContext context, int index) {
//                 // void playAyaAudio(int suraNumper, int verseIndex) {
//                 //   // Assuming that you have audio files corresponding to each ayah
//                 //   // and they are named in a way that corresponds to their verse numbers.
//                 //   // String audioPath = 'assets/audio/${verse.surahNumber}_${verse.ayahNumber}.mp3';
//                 //   String audioUrl =
//                 //       getAudioURLByVerse(suraNumper, verseIndex);
//                 //   print(audioUrl);
//                 //   widget._audioPlayer.play(UrlSource(audioUrl));
//                 // }

//                 return Column(
//                   children: [
//                     (index != 0) || (widget.sura == 0) || (widget.sura == 8)
//                         ? const Text('')
//                         : const ReturnBasmala(),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: index % 2 != 0
//                             ? const Color.fromARGB(255, 253, 251, 240)
//                             : const Color.fromARGB(255, 253, 247, 230),
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(50)),
//                       ),
//                       child: PopupMenuButton(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: verseBuilder(index, previousVerses),
//                           ),
//                           itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                   onTap: () {
//                                     saveBookMark(widget.sura + 1, index);
//                                   },
//                                   child: const Row(
//                                     children: [
//                                       Icon(
//                                         Icons.bookmark_add,
//                                         color: Color.fromARGB(255, 56, 115, 59),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text('احفظ الآيه'),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   onTap: () {
//                                     playAyaAudio(widget.sura + 1, index);
//                                   },
//                                   child: const Row(
//                                     children: [
//                                       Icon(
//                                         Icons.audiotrack_rounded,
//                                         color: Color.fromARGB(255, 56, 115, 59),
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text('استمع الي الآيه'),
//                                     ],
//                                   ),
//                                 ),
//                               ]),
//                     ),
//                   ],
//                 );
//               },
//               itemScrollController: itemScrollController,
//               itemPositionsListener: itemPositionsListener,
//               itemCount: LenghtOfSura,
//             )
//           : ListView(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           widget.sura + 1 != 1 && widget.sura + 1 != 9
//                               ? const ReturnBasmala()
//                               : const Text(''),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               fullSura, //mushaf mode
//                               textDirection: TextDirection.rtl,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: mushafFontSize,
//                                 fontFamily: arabicFont,
//                                 color: const Color.fromARGB(196, 44, 44, 44),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//     ),
//   );
// }

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
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffE95C1F),
              ),
              // ignore: dead_code
              child: ElevatedButton(
                  style: ButtonStyle(
                    //padding: EdgeInsets.all(10.0),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xffE95C1F),
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
                        borderRadius: BorderRadius.circular(30.0),
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
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffE95C1F),
              ),
              // ignore: dead_code
              child: ElevatedButton(
                  style: ButtonStyle(
                    //padding: EdgeInsets.all(10.0),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xffE95C1F),
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
                        borderRadius: BorderRadius.circular(30.0),
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
