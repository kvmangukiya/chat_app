import 'dart:async';
import 'package:chat_app/modals/color_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/title.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _acTweenText;
  late Animation _blink;
  late Animation _blink1;
  late Animation _blink2;

  @override
  void initState() {
    super.initState();

    _acTweenText =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
    _blink = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 5),
    ]).animate(_acTweenText);
    _blink1 = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 3),
    ]).animate(_acTweenText);
    _blink2 = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 4),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 1),
    ]).animate(_acTweenText);

    Timer(const Duration(seconds: 4), () async {
      Get.offNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 0.5,
                  image: AssetImage("assets/images/bkg.png"),
                  fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                AnimatedBuilder(
                  animation: _blink,
                  builder: (context, child) => Opacity(
                    opacity: _blink.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedBuilder(
                  animation: _blink1,
                  builder: (context, child) => Opacity(
                    opacity: _blink1.value,
                    child: title(
                        text: "HI Chat App...",
                        fs: 22,
                        co: ColorModal.primaryColor),
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedBuilder(
                  animation: _blink2,
                  builder: (context, child) => Opacity(
                    opacity: _blink2.value,
                    child: title(
                        text: "Your window to the world...",
                        fs: 22,
                        co: ColorModal.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
