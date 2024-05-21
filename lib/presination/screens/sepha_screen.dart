import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SephaCounter extends StatefulWidget {
  const SephaCounter({super.key});

  @override
  _SephaCounterState createState() => _SephaCounterState();
}

class _SephaCounterState extends State<SephaCounter> {
  int count = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  void incrementCount() async {
    _playTickSound();

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

  void decrementCount() {
    setState(() {
      if (count > 0) {
        count--;
      }
    });
    _playTickSound();
  }

  void resetCount() {
    setState(() {
      count = 0;
    });
    _playTickSound();
  }

  void _playTickSound() async {
    await _audioPlayer.play(AssetSource('audio/tap.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf6eb),
      appBar: AppBar(
        backgroundColor: const Color(0xfffaf6eb),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset("assets/images/paqiat.jpg"),
            const SizedBox(
              height: 80,
            ),
            Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xfffaf6eb),
                borderRadius: const BorderRadiusDirectional.vertical(
                    top: Radius.circular(20), bottom: Radius.circular(100)),
                border: Border.all(color: Colors.brown, width: 2),
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
                    width: 150,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xfffaf6eb),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.brown, width: 2),
                    ),
                    child: Text(
                      count.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: count < 999999 ? 30 : 18,
                        color: Colors.brown,
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
                        onTap: decrementCount,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown.shade100,
                          ),
                          child: const Center(
                            child: Text(
                              '-1',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: resetCount,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown.shade100,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.refresh,
                              color: Colors.brown,
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
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
