import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeInController;
  late AnimationController _fadeOutController;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeIn = CurvedAnimation(parent: _fadeInController, curve: Curves.easeIn);
    _fadeOut = CurvedAnimation(
      parent: _fadeOutController,
      curve: Curves.easeOut,
    );

    _fadeInController.forward();

    // Wait, then play fade-out and navigate
    Timer(const Duration(seconds: 2), () async {
      await _fadeOutController.forward();
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0DA70A),
      body: Center(
        child: FadeTransition(
          opacity: _fadeInController.isAnimating
              ? _fadeIn
              : _fadeOut, // transition between fade in/out
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/splash.png', width: 160),
                const SizedBox(height: 32),
                const Text(
                  'أويتك',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Text(
                  'Aweytak',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'دليلك الطبي السريع',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Your Quick Medical Guide',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
