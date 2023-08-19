import 'dart:async';
import "package:flutter/material.dart";
import 'package:powershare/screens/authentication/login.dart';
import 'package:powershare/utils/dimensions.dart';
import '../utils/power_share_heading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    // Initializing the animation variable.
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    Timer(
        // Loading the home page after the animation.
        const Duration(seconds: 5), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: const LoginScreen(),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Image.asset(
                "assets/image/pisi.jpg",
                width: Dimensions.splashImgwidth,
              ),
            ),
          ),
          const Center(
            child: PowerShareHeading(),
          ),
        ],
      ),
    );
  }
}
