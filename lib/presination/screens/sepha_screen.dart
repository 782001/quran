import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';

class SephaScreen extends StatefulWidget {
  const SephaScreen({super.key});

  @override
  _SephaScreenState createState() => _SephaScreenState();
}

class _SephaScreenState extends State<SephaScreen> {
  int count = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isAudioEnabled = true;
  void incrementCount() async {
    if (isAudioEnabled) {
      _playTickSound();
    }

    setState(() {
      count++;
    });
  }

  // @override
  // void dispose() {
  //   player.dispose();
  //   // _controllerTopCenter!.dispose();

  //   super.dispose();
  // }

  void toggleAudio() {
    if (isAudioEnabled) {
      _playTickSound();
    }
    setState(() {
      isAudioEnabled = !isAudioEnabled;
    });
  }

  void resetCount() {
    setState(() {
      count = 0;
    });
    if (isAudioEnabled) {
      _playTickSound();
    }
  }

  void _playTickSound() async {
    await _audioPlayer.play(AssetSource('audio/tap.wav'));
  }

  @override
  Widget build(BuildContext context) {
    List<TaspehModel> TaspehList = [
      TaspehModel(title: "سُبْحَانَ اللَّهِ", id: 1),
      TaspehModel(
          title: "الْلَّهُم صَلِّ وَسَلِم وَبَارِك عَلَى سَيِّدِنَا مُحَمَّد ",
          id: 2),
      TaspehModel(
          title:
              " سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
          id: 3),
      TaspehModel(title: "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ", id: 4),
      TaspehModel(title: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ", id: 5),
      TaspehModel(
          title:
              "لَا إلَه إلّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلُّ شَيْءِ قَدِيرِ.",
          id: 6),
      TaspehModel(title: " لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ ", id: 7),
      TaspehModel(title: "الْحَمْدُ للّهِ رَبِّ الْعَالَمِينَ ", id: 8),
      TaspehModel(title: "أستغفر الله", id: 9),
      TaspehModel(title: "سُبْحَانَ اللهِ العَظِيمِ وَبِحَمْدِهِ", id: 10),
      TaspehModel(
          title:
              " اللَّهُ أَكْبَرُ كَبِيرًا ، وَالْحَمْدُ لِلَّهِ كَثِيرًا ، وَسُبْحَانَ اللَّهِ بُكْرَةً وَأَصِيلاً.",
          id: 11),
      TaspehModel(
          title:
              "سُبْحَانَ اللَّهِ ، وَالْحَمْدُ لِلَّهِ ، وَلا إِلَهَ إِلا اللَّهُ ، وَاللَّهُ أَكْبَرُ ، اللَّهُمَّ اغْفِرْ لِي ، اللَّهُمَّ ارْحَمْنِي ، اللَّهُمَّ ارْزُقْنِي.",
          id: 12),
      TaspehModel(
          title:
              "سُبْحَانَ الْلَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا الْلَّهُ، وَالْلَّهُ أَكْبَرُ",
          id: 13),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfffaf6eb),
      // appBar: AppBar(
      //   backgroundColor: const Color(0xfffaf6eb),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/paqiat.jpg"),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            SizedBox(
              // width: context.width * 0.7,
              height: context.height * 0.3,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return TaspehText(TaspehList[index], context);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox.shrink();
                },
                itemCount: TaspehList.length,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 250,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xfffaf6eb),
                borderRadius: const BorderRadiusDirectional.vertical(
                    top: Radius.circular(20), bottom: Radius.circular(100)),
                border: Border.all(color: const Color(0xff592c01), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xfffaf6eb),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xff592c01), width: 2),
                    ),
                    child: Text(
                      count.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: count < 999999 ? 30 : 18,
                        color: const Color(0xff592c01),
                        fontFamily: 'Orbitron', // Use the custom font here
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: toggleAudio,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown.shade100,
                          ),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.brown.shade100,
                            ),
                            child: Center(
                              child: Icon(
                                isAudioEnabled
                                    ? Icons.volume_up
                                    : Icons.volume_off,
                                color: const Color(0xff592c01),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: resetCount,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown.shade100,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.refresh,
                              color: Color(0xff592c01),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: incrementCount,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff592c01),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Padding TaspehText(TaspehModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, bottom: 20, end: 20),
      child: Container(
        width: context.width * 0.75,
        // height: context.height * 0.05,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Color(0xff592c01)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              model.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontFamily: cairoFont,
                fontSize: context.width * 0.06,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaspehModel {
  final String title;
  final int id;

  TaspehModel({
    required this.title,
    required this.id,
  });
}
