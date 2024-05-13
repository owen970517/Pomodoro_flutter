import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  static const fiveMinutes = 300;
  bool isStart = false;
  bool isRest = false;
  int totalSeconds = twentyFiveMinutes;
  int restSeconds = fiveMinutes;
  int currentRounds = 1;
  int maxRounds = 4;
  late Timer timer;
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isStart = !isStart;
        isRest = !isRest;
        if (isRest) {
          currentRounds = currentRounds + 1;
          totalSeconds = restSeconds;
        } else {
          totalSeconds = twentyFiveMinutes;
        }
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onPause() {
    timer.cancel();
    setState(() {
      isStart = false;
    });
  }

  void onStartPress() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isStart = true;
    });
  }

  void onRestart() {
    setState(() {
      totalSeconds = twentyFiveMinutes;
    });
  }

  String timeFormat(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                timeFormat(totalSeconds),
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 80,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isRest ? '휴식을 취하세요' : '집중을 시작하세요'),
                  IconButton(
                    iconSize: 90,
                    color: Theme.of(context).cardColor,
                    onPressed: isStart ? onPause : onStartPress,
                    icon: Icon(isStart
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline),
                  ),
                  IconButton(
                      iconSize: 90,
                      color: Theme.of(context).cardColor,
                      onPressed: onRestart,
                      icon: const Icon(Icons.restart_alt_outlined)),
                ],
              )),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Round',
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$currentRounds / $maxRounds',
                          style: TextStyle(
                              fontSize: 60,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
