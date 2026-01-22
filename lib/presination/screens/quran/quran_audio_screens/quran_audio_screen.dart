import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/models/audio_sura_model.dart';
import 'package:quran_v2/presination/widgets/sura_audio_player.dart';

class QuranAudioScreen extends StatefulWidget {
  const QuranAudioScreen(
      {Key? key,
      required this.audioUrl,
      required this.surahNumber,
      required this.reciter,
      required this.SuraName,
      required this.reciterName})
      : super(key: key);
  final String audioUrl;
  final String SuraName;
  final ReciterAudio reciter;
  final int surahNumber;
  final String reciterName;

  @override
  _QuranAudioScreenState createState() => _QuranAudioScreenState();
}

class _QuranAudioScreenState extends State<QuranAudioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Time for one animation cycle
    )..repeat(reverse: true); // Repeats the animation and reverses it

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smooth animation curve
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const SizedBox.shrink();
          },
        ),
        backgroundColor: const Color(0xff592c01),
        title: AutoSizeText(
          widget.SuraName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.06,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          ": قراءه رائعه بصوت الشيخ  \n${widget.reciterName}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: cairoFont,
                            fontSize: context.width * 0.04,
                            color: const Color(0xff592c01),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * .07,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "ملحوظة \n ان واجهت مشكلة اثناء الاستماع الي السورة \n يمكنك الضغط علي زر تحميل السورة بالاسفل حيث سيتم تحميل السورة علي جهازك ويمكن الاستماع عليها من جهازك",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: cairoFont,
                            fontSize: context.width * 0.04,
                            color: MyColors.babyBrown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * .07,
                      ),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(audioBackgroundImage),
                      ),
                      const Spacer(), // Pushes the `SuraAudioPlayer` to the bottom
                      SuraAudioPlayer(
                          shekhNam: widget.reciterName,
                          suraNam: widget.SuraName,
                          reciter: widget.reciter,
                          surahNumber: widget.surahNumber,
                          audioUrl: widget.audioUrl),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
