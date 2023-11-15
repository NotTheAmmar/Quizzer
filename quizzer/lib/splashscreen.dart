import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/playerSelectionPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _RotatingLogo(width: 400, height: 300),
            const Gap(40),
            Text("Quizzer", style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _RotatingLogo extends StatefulWidget {
  final double width, height;

  const _RotatingLogo({required this.width, required this.height});

  @override
  State<_RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<_RotatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: Image.asset(
        'assets/icons/quizzer.png',
        width: widget.width,
        height: widget.height,
      ),
      builder: (context, child) {
        return Transform.rotate(angle: _animation.value * 6.3, child: child);
      },
    );
  }
}
