import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroCard extends StatefulWidget {
  const GyroCard({super.key});

  @override
  State<GyroCard> createState() => _GyroCardState();
}

class _GyroCardState extends State<GyroCard> {
  late final StateMachineController _controller;
  late final StreamSubscription<GyroscopeEvent> _gyroStreamSubscription;
  SMIInput<double>? xInput;
  SMIInput<double>? yInput;

  double x = 0;
  double y = 0;
  static const double maxMovableDistance = 10;

  @override
  void initState() {
    _gyroStreamSubscription = gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        x += event.y / 6;
        y += event.x / 6;

        x = x.clamp(-maxMovableDistance, maxMovableDistance);
        y = y.clamp(-maxMovableDistance, maxMovableDistance);

        xInput?.value = -x;
        yInput?.value = y;
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );

    super.initState();
  }

  Future<void> _onRiveInit(Artboard artboard) async {
    _controller = StateMachineController.fromArtboard(artboard, 'card')!;
    xInput = _controller.findInput('xAxis');
    yInput = _controller.findInput('yAxis');
    artboard.addController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/card.riv',
      artboard: 'card',
      fit: BoxFit.cover,
      onInit: _onRiveInit,
    );
  }

  @override
  void dispose() {
    _gyroStreamSubscription.cancel();
    super.dispose();
  }
}
