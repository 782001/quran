import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/presination/screens/quran/quran_reading/surah_builder.dart';
import 'package:rxdart/rxdart.dart';

Future<Uri> getAssetUri(String assetPath) async {
  final ByteData data = await rootBundle.load(assetPath);
  final Directory tempDir = await getTemporaryDirectory();
  final File file = File('${tempDir.path}/quran.png');

  await file.writeAsBytes(data.buffer.asUint8List());

  return file.uri;
}

class SuraAudioPlayer extends StatefulWidget {
  final String audioUrl;
  final String suraNam;
  final String shekhNam;

  const SuraAudioPlayer(
      {Key? key,
      required this.audioUrl,
      required this.suraNam,
      required this.shekhNam})
      : super(key: key);

  @override
  _SuraAudioPlayerState createState() => _SuraAudioPlayerState();
}

class _SuraAudioPlayerState extends State<SuraAudioPlayer> {
  late AudioPlayer audioPlayer = AudioService.instance;

  bool isLooping = false;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool haveTotalduration = false;
  bool loadingDownload = false;
  int isDownload = 0;
  Stream<PossitionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PossitionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PossitionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();

    _initializeAudioPlayer();

    // Listen for changes in player state
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {}); // Update UI when audio completes
      }
    });

    // if (duration == Duration.zero) {
    //   setState(() {
    //     haveTotalduration = false;
    //   });
    // } else {
    //   setState(() {
    //     haveTotalduration =
    //         true; // Update UI or variables once the duration is loaded
    //   });
    // }
    audioPlayer.durationStream.listen((duration) {
      setState(() {
        // haveTotalduration = duration != null && duration != Duration.zero;
        haveTotalduration = false;
      });
    });
  }

  Future<void> _initializeAudioPlayer() async {
    Uri assetUri = await getAssetUri('assets/images/quran.png');
    try {
      await audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.parse(widget.audioUrl),
            tag: MediaItem(
              id: '1',
              album: widget.suraNam,
              title: widget.shekhNam,
              artUri: assetUri,
            ),
            headers: {"User-Agent": "Mozilla/5.0"},
          ),
          preload: true);

      // Listen to duration changes instead of fetching it immediately
      // audioPlayer.durationStream.listen((duration) {
      //   setState(() {
      //     haveTotalduration = duration != null && duration != Duration.zero;
      //   });
      // });
    } catch (e) {
      log("Error setting URL: $e");
    }
  }

  Future<Duration?> getAudioDuration() async {
    try {
      return audioPlayer.duration; // Fetch the duration
    } catch (e) {
      // ShowToust(Text: e.toString(), state: ToustStates.ERROR);
      return null; // Return null if fetching duration fails
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final houres = duration.inHours.remainder(60).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$houres:$minutes:$seconds';
  }

  void _seek(Duration offset) async {
    final currentPosition = audioPlayer.position;
    final totalDuration = audioPlayer.duration;

    if (totalDuration == null) {
      // Duration not loaded yet; ignore seek operation
      return;
    } else {
      log('Current duration: $totalDuration');
    }

    final newPosition = currentPosition + offset;
    log('Current Position: $currentPosition');
    log('Seeking to: $newPosition');

    print("Seeking is  supported.");
    if (newPosition < Duration.zero) {
      await audioPlayer.seek(Duration.zero);
    } else if (newPosition > totalDuration) {
      await audioPlayer.seek(totalDuration);
    } else {
      await audioPlayer.seek(newPosition);
    }
    // await audioPlayer.seek(newPosition);
    // Ensure playback continues from the new position
    if (audioPlayer.playing) {
      await audioPlayer.play();
    }
    //
    // setState(() {
    //   haveTotalduration =
    //       true; // Update UI or variables once the duration is loaded
    // });

    log('New Position after seek: ${audioPlayer.position}');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, playerSnapshot) {
        final isPlaying = playerSnapshot.data?.playing ?? false;
        void togglePlayPause() async {
          if (audioPlayer.playing) {
            // audioPlayer.setUrl(widget.audioUrl);
            await audioPlayer.pause();
            audioPlayer.positionStream;
            audioPlayer.bufferedPositionStream;
            audioPlayer.durationStream;
          } else {
            isDeviceConnected = await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              ShowToust(Text: "لا يوجد انترنت", state: ToustStates.SUCSESS);
              setState(() {
                isAlertSet = true;
              });
            }
            if (audioPlayer.playerState.processingState ==
                ProcessingState.completed) {
              await audioPlayer.seek(Duration.zero); // Reset audio to start
            }
            setState(() {
              isPlaying == false;
            });

            await audioPlayer.play();
            audioPlayer.positionStream;
            audioPlayer.bufferedPositionStream;
            audioPlayer.durationStream;
            // await audioPlayer.play();
          }
        }

        return StreamBuilder<Duration?>(
          stream: audioPlayer.durationStream,
          builder: (context, durationSnapshot) {
            final totalDuration =
                durationSnapshot.data ?? const Duration(minutes: 3);

            return StreamBuilder<Duration>(
              stream: audioPlayer.positionStream,
              builder: (context, positionSnapshot) {
                final currentPosition =
                    positionSnapshot.data ?? const Duration(seconds: 2);
                // log("currentPosition:$currentPosition");
                if (totalDuration == Duration.zero) {
                  // Wait for audio duration to load before showing the controls
                  // return const Center(
                  //     child: CircularProgressIndicator(
                  //   color: Color(0xff592c01),
                  // ));
                }

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff592c01),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!haveTotalduration)
                              Text(
                                _formatDuration(currentPosition),
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (haveTotalduration)
                              IconButton(
                                icon: const Icon(Icons.replay_10_rounded),
                                iconSize: 48,
                                color: Colors.white,
                                onPressed: () =>
                                    _seek(const Duration(seconds: -10)),
                              ),
                            IconButton(
                              icon: Icon(isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle),
                              iconSize: 64,
                              color: Colors.white,
                              onPressed: togglePlayPause,
                            ),
                            if (haveTotalduration)
                              IconButton(
                                icon: const Icon(Icons.forward_10_rounded),
                                iconSize: 48,
                                color: Colors.white,
                                onPressed: () =>
                                    _seek(const Duration(seconds: 10)),
                              ),
                            IconButton(
                              icon: Icon(isLooping
                                  ? Icons.repeat_one_outlined
                                  : Icons.repeat),
                              iconSize: 48,
                              color: isLooping ? Colors.white : Colors.grey,
                              onPressed: () {
                                setState(() {
                                  isLooping = !isLooping;
                                  audioPlayer.setLoopMode(
                                      isLooping ? LoopMode.one : LoopMode.off);
                                  if (isLooping) {
                                    ShowToust(
                                        Text: "سيتم تكرار السورة",
                                        state: ToustStates.SUCSESS);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              tooltip: "تحميل السورة",
                              icon: loadingDownload
                                  ? const CircularProgressIndicator(
                                      color: MyColors.lightBrown,
                                    )
                                  : const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                              iconSize: 48,
                              color: Colors.white,
                              onPressed: () {
                                bool havemp3 = false;
                                if (widget.audioUrl.contains(".mp3")) {
                                  setState(() {
                                    havemp3 = true;
                                  });
                                } else {
                                  setState(() {
                                    havemp3 = false;
                                  });
                                }
                                loadingDownload
                                    ? ShowToust(
                                        state: ToustStates.SUCSESS,
                                        Text: 'يتم التحميل الان')
                                    : FileDownloader.downloadFile(
                                        url: widget.audioUrl,
                                        name:
                                            "القرآن الكريم بصوت ${widget.shekhNam}- ${widget.suraNam}${havemp3 ? "" : ".mp3"}", //(optional)
                                        onProgress: (String? fileName,
                                            double? progress) {
                                          setState(() {
                                            loadingDownload = true;
                                          });
                                          print(
                                              'FILE fileName HAS PROGRESS $progress');
                                        },
                                        onDownloadCompleted: (String path) {
                                          setState(() {
                                            loadingDownload = false;
                                          });
                                          ShowToust(
                                              state: ToustStates.SUCSESS,
                                              Text: 'تم التحميل بنجاح');
                                        },
                                        onDownloadError: (String error) {
                                          setState(() {
                                            loadingDownload = false;
                                          });
                                          ShowToust(
                                              state: ToustStates.ERROR,
                                              Text:
                                                  'تأكد من اتصالك بالانترنيت');
                                        });
                              },
                            ),
                          ],
                        ),
                      ),
                      if (haveTotalduration)
                        Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          value: currentPosition.inSeconds.toDouble(),
                          min: 0.0,
                          max: totalDuration.inSeconds.toDouble() ?? 1.0,
                          onChanged: totalDuration != null
                              ? (value) {
                                  final newPosition =
                                      Duration(seconds: value.toInt());
                                  audioPlayer.seek(newPosition);
                                }
                              : null, // Disable slider if duration is not available
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (haveTotalduration)
                              Text(
                                _formatDuration(currentPosition),
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (haveTotalduration)
                              Text(
                                _formatDuration(totalDuration),
                                style: const TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class PossitionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  const PossitionData(this.position, this.bufferedPosition, this.duration);
}

//------------------ Hizb Data ---------------------

// List HizbQaurter = [
//   // [sura, aya]
//   [],
//   [1, 1], [2, 26], [2, 44], [2, 60],
//   [2, 75], [2, 92], [2, 106], [2, 124],
//   [2, 142], [2, 158], [2, 177], [2, 189],
//   [2, 203], [2, 219], [2, 233], [2, 243],
//   [2, 253], [2, 263], [2, 272], [2, 283],
//   [3, 15], [3, 33], [3, 52], [3, 75],
//   [3, 93], [3, 113], [3, 133], [3, 153],
//   [3, 171], [3, 186], [4, 1], [4, 12],
//   [4, 24], [4, 36], [4, 58], [4, 74],
//   [4, 88], [4, 100], [4, 114], [4, 135],
//   [4, 148], [4, 163], [5, 1], [5, 12],
//   [5, 27], [5, 41], [5, 51], [5, 67],
//   [5, 82], [5, 97], [5, 109], [6, 13],
//   [6, 36], [6, 59], [6, 74], [6, 95],
//   [6, 111], [6, 127], [6, 141], [6, 151],
//   [7, 1], [7, 31], [7, 47], [7, 65],
//   [7, 88], [7, 117], [7, 142], [7, 156],
//   [7, 171], [7, 189], [8, 1], [8, 22],
//   [8, 41], [8, 61], [9, 1], [9, 19],
//   [9, 34], [9, 46], [9, 60], [9, 75],
//   [9, 93], [9, 111], [9, 122], [10, 11],
//   [10, 26], [10, 53], [10, 71], [10, 90],
//   [11, 6], [11, 24], [11, 41], [11, 61],
//   [11, 84], [11, 108], [12, 7], [12, 30],
//   [12, 53], [12, 77], [12, 101], [13, 5],
//   [13, 19], [13, 35], [14, 10], [14, 28],
//   [15, 1], [15, 50], [16, 1], [16, 30],
//   [16, 51], [16, 75], [16, 90], [16, 111],
//   [17, 1], [17, 23], [17, 50], [17, 70],
//   [17, 99], [18, 17], [18, 32], [18, 51],
//   [18, 75], [18, 99], [19, 22], [19, 59],
//   [20, 1], [20, 55], [20, 83], [20, 111],
//   [21, 1], [21, 29], [21, 51], [21, 83],
//   [22, 1], [22, 19], [22, 38], [22, 60],
//   [23, 1], [23, 36], [23, 75], [24, 1],
//   [24, 21], [24, 35], [24, 53], [25, 1],
//   [25, 21], [25, 53], [26, 1], [26, 52],
//   [26, 111], [26, 181], [27, 1], [27, 27],
//   [27, 56], [27, 82], [28, 12], [28, 29],
//   [28, 51], [28, 76], [29, 1], [29, 26],
//   [29, 46], [30, 1], [30, 31], [30, 54],
//   [31, 22], [32, 11], [33, 1], [33, 18],
//   [33, 31], [33, 51], [33, 60], [34, 10],
//   [34, 24], [34, 46], [35, 15], [35, 41],
//   [36, 28], [36, 60], [37, 22], [37, 83],
//   [37, 145], [38, 21], [38, 52], [39, 8],
//   [39, 32], [39, 53], [40, 1], [40, 21],
//   [40, 41], [40, 66], [41, 9], [41, 25],
//   [41, 47], [42, 13], [42, 27], [42, 51],
//   [43, 24], [43, 57], [44, 17], [45, 12],
//   [46, 1], [46, 21], [47, 10], [47, 33],
//   [48, 18], [49, 1], [49, 14], [50, 27],
//   [51, 31], [52, 24], [53, 26], [54, 9],
//   [55, 1], [56, 1], [56, 75], [57, 16],
//   [58, 1], [58, 14], [59, 11], [60, 7],
//   [62, 1], [63, 4], [65, 1], [66, 1],
//   [67, 1], [68, 1], [69, 1], [70, 19],
//   [72, 1], [73, 20], [75, 1], [76, 19],
//   [78, 1], [80, 1], [82, 1], [84, 1],
//   [87, 1], [90, 1], [94, 1], [100, 9],
//   [115, 1]
// ];
