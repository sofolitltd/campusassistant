import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/widgets/app_logo.dart';

class NewSplashScreen extends ConsumerStatefulWidget {
  const NewSplashScreen({super.key});

  @override
  ConsumerState<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends ConsumerState<NewSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Create the animation
    _animation = Tween<double>(begin: .9, end: 1).animate(_controller);

    // Add a listener to the animation to repeat the animation in a loop
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(scale: _animation, child: const AppLogo()),
      ),
    );
  }
}
