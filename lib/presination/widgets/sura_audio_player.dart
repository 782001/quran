import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:rxdart/rxdart.dart';

class SuraAudioPlayer extends StatefulWidget {
  final String audioUrl;

  const SuraAudioPlayer({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _SuraAudioPlayerState createState() => _SuraAudioPlayerState();
}

class _SuraAudioPlayerState extends State<SuraAudioPlayer> {
  late AudioPlayer audioPlayer;
  bool isLooping = false;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool haveTotalduration = true;
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
  }

  Future<void> _initializeAudioPlayer() async {
    final duration = await _getAudioDuration();
    if (duration == null || duration == Duration.zero) {
      setState(() {
        haveTotalduration = false;
      });
      ShowToust(
          Text: "لم يتم تحديد مدة المقطع الصوتي", state: ToustStates.ERROR);
    } else {
      setState(() {
        haveTotalduration =
            true; // Update UI or variables once the duration is loaded
      });
    }
  }


  Future<Duration?> _getAudioDuration() async {
    try {
      await audioPlayer.setUrl(widget.audioUrl); // Load the audio URL
      return audioPlayer.duration; // Fetch the duration
    } catch (e) {
      ShowToust(Text: e.toString(), state: ToustStates.ERROR);
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
    }

    final newPosition = currentPosition + offset;

    if (newPosition < Duration.zero) {
      await audioPlayer.seek(Duration.zero);
    } else if (newPosition > totalDuration) {
      await audioPlayer.seek(totalDuration);
    } else {
      await audioPlayer.seek(newPosition);
    }
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
            setState(() {
              isPlaying == false;
            });

            await audioPlayer.play();
            audioPlayer.positionStream;
            audioPlayer.bufferedPositionStream;
            audioPlayer.durationStream;
          }
        }

        return StreamBuilder<Duration?>(
          stream: audioPlayer.durationStream,
          builder: (context, durationSnapshot) {
            final totalDuration =
                durationSnapshot.data ?? const Duration(minutes: 20);

            return StreamBuilder<Duration>(
              stream: audioPlayer.positionStream,
              builder: (context, positionSnapshot) {
                final currentPosition = positionSnapshot.data ?? Duration.zero;

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
                      Row(
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
                        ],
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
