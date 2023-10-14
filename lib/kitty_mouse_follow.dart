import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';

class KittyMouseFollow extends StatefulWidget {
  const KittyMouseFollow({super.key});

  @override
  State<KittyMouseFollow> createState() => _KittyMouseFollowState();
}

class _KittyMouseFollowState extends State<KittyMouseFollow> {
  StateMachineController? controller;
  late final StreamSubscription<GyroscopeEvent> _gyroStreamSubscription;

  // Artboard Size is 1200 x 1200. the x,y is the center of artboard
  double x = 600;
  double y = 500;

  @override
  void initState() {
    _gyroStreamSubscription = gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        x += -event.y * 4;
        y += -event.x * 4;

        // simulate cursor movement
        controller?.pointerMove(Vec2D.fromOffset(Offset(x, y)));
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    _gyroStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // disable user interaction on the artboard
          IgnorePointer(
        child: RiveAnimation.asset(
          // Source file
          // https://rive.app/community/5997-11672-kitty-test-mouse-follow/
          'assets/kitty.riv',
          artboard: 'Cat lines.svg',
          fit: BoxFit.cover,
          onInit: (artboard) {
            final controller = StateMachineController.fromArtboard(
                artboard, 'State Machine 1')!;

            artboard.addController(controller);
            this.controller = controller;
          },
        ),
      ),
    );
  }
}
