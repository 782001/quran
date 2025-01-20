import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerApp(),
    );
  }
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_hours == 0 && _minutes == 0 && _seconds == 0) {
          _timer.cancel();
          // Timer has finished, you can perform an action here.
        } else if (_minutes == 0 && _seconds == 0) {
          _hours--;
          _minutes = 59;
          _seconds = 59;
        } else if (_seconds == 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _seconds--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer'),
      ),
      body: Center(
        child: Text(
          'Time remaining: $_hours hours $_minutes minutes $_seconds seconds',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
