import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  final bool playAnimation;
  const HomePage({super.key, required this.playAnimation});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          border: null,
          leading: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(
                width: 8,
              ),
              if (widget.playAnimation == true)
                const Expanded(
                  child: RiveAnimation.asset('assets/welcome_message.riv'),
                )
            ],
          ),
        ),
        body: Stack(
          children: [
            const RiveAnimation.asset('assets/shapes.riv'),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 50.0,
                sigmaY: 50.0,
              ),
              child: const SizedBox(),
            ),
          ],
        ));
  }
}
