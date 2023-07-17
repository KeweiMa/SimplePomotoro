import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/settingPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Digital Clock & Pomotoro App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer? _timer;
  int timerStatus = 0;
  Duration duration = Duration(minutes: 25);

  @override
  void initState() {
    super.initState();
  }

  Widget buildTimerWidget() {
    String strDigit(int n) => n.toString().padLeft(2, '0');
    final min = strDigit(duration.inMinutes.remainder(60));
    final sec = strDigit(duration.inSeconds.remainder(60));

    return Text(
      '$min : $sec',
      style: const TextStyle(color: Colors.white, fontSize: 50),
    );
  }

  Widget buildMenuWidget() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingPage()));
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
      child: const Icon(Icons.menu, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => _pauseStart(),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: [
            Positioned(
              top: size.height * 0.45,
              left: size.width * 0.35,
              child: buildTimerWidget(),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: buildMenuWidget(),
            )
          ])),
    );
  }

  void _pauseStart() {
    if (timerStatus == 1) {
      setState(() => _timer!.cancel()); // stop timer
      timerStatus = 0;
    } else if (timerStatus == 0) {
      _timer = Timer.periodic(
          Duration(seconds: 1), (_) => _setCountDown()); // start timer
      timerStatus = 1;
    } else {
      setState(() => _timer!.cancel());
      setState(() => duration = Duration(minutes: 25));
    }
    //print(timerStatus);
  }

  void _setCountDown() {
    const reducedBy = 1;

    setState(() {
      final seconds = duration.inSeconds - reducedBy;
      if (seconds < 0) {
        _timer!.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }
}
