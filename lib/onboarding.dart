import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_demo/home_page.dart';
import 'package:rive_demo/l10n/l10n.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();

  /// Controller for playback
  late ScrubController _controller;
  SMIInput<bool>? _completeOnboardingInput;

  SMIInput<double>? _pageIndicatorProgress;

  bool onboardingCompleted = false;
  bool onboardingFadeInStarted = false;
  @override
  void initState() {
    super.initState();
    _controller = ScrubController('Timeline');

    pageController.addListener(() {
      const scrollablePagesCount = 3;
      final pageProgress =
          pageController.offset / MediaQuery.of(context).size.width;

      _pageIndicatorProgress?.value = pageProgress * 100;

      final progress = (pageProgress / scrollablePagesCount) *
          _controller.instance!.animation.durationSeconds;
      _controller.instance!.time = progress;
    });
  }

  void onRiveEvent(RiveEvent event) {
    if (event.name == 'onboardingFadeInStarted') {
      Future.microtask(() {
        setState(() {
          onboardingFadeInStarted = true;
        });
      });
    } else if (event.name == 'onboardingCompleted') {
      Future.microtask(() {
        setState(
          () {
            onboardingCompleted = true;
          },
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomePage(
          playAnimation: onboardingCompleted,
        ),
        if (!onboardingCompleted)
          RiveAnimation.asset(
            'assets/onboarding.riv',
            artboard:
                MediaQuery.sizeOf(context).width > 750 ? 'tablet' : 'phone',
            fit: BoxFit.cover,
            controllers: [_controller],
            // Update the play state when the widget's initialized
            onInit: (artboard) async {
              final page1Title = artboard.textRun('page 1 title')!;
              final page1Subtitle = artboard.textRun('page 1 subtitle')!;

              final page2Title = artboard.textRun('page 2 title')!;
              final page2Subtitle = artboard.textRun('page 2 subtitle')!;

              final page3Title = artboard.textRun('page 3 title')!;
              final page3Subtitle = artboard.textRun('page 3 subtitle')!;

              final page4Title = artboard.textRun('page 4 title')!;
              final page4Subtitle = artboard.textRun('page 4 subtitle')!;

              page1Title.text = context.l10n.page1Title;
              page1Subtitle.text = context.l10n.page1Subtitle;

              page2Title.text = context.l10n.page2Title;
              page2Subtitle.text = context.l10n.page2Subtitle;

              page3Title.text = context.l10n.page3Title;
              page3Subtitle.text = context.l10n.page3Subtitle;

              page4Title.text = context.l10n.page4Title;
              page4Subtitle.text = context.l10n.page4Subtitle;

              var controller =
                  StateMachineController.fromArtboard(artboard, 'onboarding')!;
              controller.isActive = false;
              artboard.addController(controller);
              controller.addEventListener(onRiveEvent);
              _completeOnboardingInput =
                  controller.findInput('completeOnboarding');

              artboard.addController(controller);
            },
          ),
        SafeArea(
          child: AnimatedOpacity(
            opacity: onboardingFadeInStarted ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: RiveAnimation.asset(
                      'assets/onboarding.riv',
                      artboard: 'login button',
                      onInit: (artboard) {
                        final controller = StateMachineController.fromArtboard(
                            artboard, 'State Machine 1')!;

                        // run the state machine
                        artboard.addController(controller);
                        final getStartedLabel = artboard.textRun('login')!;
                        getStartedLabel.text = context.l10n.getStartedLabel;

                        controller.addEventListener((event) {
                          if (event.name == 'getStartedPressed') {
                            _completeOnboardingInput?.value = true;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: RiveAnimation.asset(
                      'assets/onboarding.riv',
                      artboard: 'page indicator',
                      onInit: (artboard) {
                        // Page Indicator State Machine Controller
                        final controller = StateMachineController.fromArtboard(
                            artboard, 'State Machine')!;
                        // run the state machine
                        artboard.addController(controller);
                        _pageIndicatorProgress =
                            controller.findInput('progress');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!onboardingCompleted)
          TransparentPointer(
            child: SafeArea(
              child: PageView(
                controller: pageController,
                physics: const ClampingScrollPhysics(),
                children: const [
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class ScrubController extends SimpleAnimation {
  ScrubController(
    String animationName, {
    double mix = 1,
  }) : super(animationName, mix: mix, autoplay: true);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!.animation.apply(instance!.time, coreContext: artboard, mix: mix);
  }
}

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}
