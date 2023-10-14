import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class WaterBarDemo extends StatefulWidget {
  const WaterBarDemo({super.key});

  @override
  State<WaterBarDemo> createState() => _WaterBarDemoState();
}

class _WaterBarDemoState extends State<WaterBarDemo> {
  SMIInput<double>? _progress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        RiveAnimation.asset(
          'assets/water-bar-demo.riv',
          fit: BoxFit.cover,
          onInit: (artboard) {
            final controller =
                StateMachineController.fromArtboard(artboard, 'State Machine')!;
            _progress = controller.findInput('Level');
            artboard.addController(controller);
          },
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Slider(
                  max: 100,
                  value: _progress?.value ?? 30,
                  onChanged: (newValue) {
                    setState(() {
                      _progress?.value = newValue;
                    });
                  })
            ],
          ),
        )
      ]),
    );
  }
}
