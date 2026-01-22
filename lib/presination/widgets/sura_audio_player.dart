import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/screens/quran/quran_reading/surah_builder.dart';
import 'package:quran_v2/presination/widgets/quran_audio_service.dart';
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
  final int surahNumber;
  final ReciterAudio reciter;

  const SuraAudioPlayer(
      {Key? key,
      required this.audioUrl,
      required this.suraNam,
      required this.surahNumber,
      required this.reciter,
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

  final service = QuranAudioService();
  Future<void> _downloadSurah(ReciterAudio reciter, int suraNum) async {
    final service = QuranAudioService();
    bool downloaded = await service.isDownloaded(
        reciterName: reciter.reciterName, surahNumber: suraNum);

    if (!context.mounted) return;

    if (downloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text("السورة محمّلة بالفعل"),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

    // Dialog التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ValueListenableBuilder<double>(
        valueListenable: progressNotifier,
        builder: (context, progress, _) {
          if (progress >= 1.0) {
            Future.microtask(() {
              if (context.mounted)
                Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text("تم تحميل ${reciter.reciterName} بنجاح"),
                  ),
                  backgroundColor: const Color(0xff592c01),
                  duration: const Duration(seconds: 2),
                ),
              );
              setState(() {}); // تحديث الـ icon بعد التحميل
            });
          }
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text(
                "جاري تحميل السورة",
                style: TextStyle(
                    fontFamily: cairoFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  color: const Color(0xff592c01),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 12),
                Text(
                  "${(progress * 100).toStringAsFixed(0)} %",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );

    // بدء التحميل
    await service.downloadSurah(
      url: reciter.audioUrl,
      reciterName: reciter.reciterName,
      surahNumber: suraNum,
      onProgress: (p) {
        progressNotifier.value = p;
      },
    );
  }

  Future<void> _initializeAudioPlayer() async {
    Uri assetUri = await getAssetUri('assets/images/quran.png');

    final isOffline = await service.isDownloaded(
      reciterName: widget.shekhNam,
      surahNumber: widget.surahNumber,
    );

    if (isOffline) {
      // السورة محملة -> تشغيل من الجهاز
      final path = await service.getSurahPath(
        reciterName: widget.shekhNam,
        surahNumber: widget.surahNumber,
      );
      await audioPlayer.setAudioSource(
        AudioSource.file(
          path,
          tag: MediaItem(
            id: widget.surahNumber.toString(),
            album: widget.suraNam,
            title: widget.shekhNam,
            artUri: assetUri, // نفس الصورة المستخدمة في الانترنت
          ),
        ),
        preload: true,
      );
    } else {
      // السورة غير محملة -> تشغيل من الانترنت
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
          preload: true,
        );
      } catch (e) {
        log("Error setting URL: $e");
        ShowToust(Text: "حدث خطأ أثناء التحميل", state: ToustStates.ERROR);
      }
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
                            FutureBuilder<bool>(
                              future: QuranAudioService().isDownloaded(
                                  reciterName: widget.reciter.reciterName,
                                  surahNumber: widget.surahNumber),
                              builder: (context, snapshot) {
                                final downloaded = snapshot.data ?? false;

                                return (downloaded)
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : ElevatedButton(
                                        onPressed: () => _downloadSurah(
                                            widget.reciter, widget.surahNumber),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                        ),
                                        child: const Text(
                                          "تحميل",
                                          style: TextStyle(
                                              color: Color(0xff592c01),
                                              fontFamily: cairoFont,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
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
