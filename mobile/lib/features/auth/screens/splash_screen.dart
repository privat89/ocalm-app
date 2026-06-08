import 'package:flutter/material.dart';
import '../../../core/theme/ocalm_colors.dart';
import '../../../core/theme/ocalm_animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _glowController;
  late AnimationController _ringController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _glowPulse;
  late Animation<double> _ringExpand;
  late Animation<double> _ringFade;

  @override
  void initState() {
    super.initState();

    // Logo: scale + fade in
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: OcalmAnimations.entryCurve),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.6)),
    );

    // Text: fade + slide up
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: OcalmAnimations.defaultCurve),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 20), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: OcalmAnimations.defaultCurve),
    );

    // Glow: pulsing loop
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _glowPulse = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Ring: expanding ripple
    _ringController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _ringExpand = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );
    _ringFade = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _glowController.repeat(reverse: true);
    _ringController.repeat();

    // Navigate after 3s
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      // TODO: Navigate to onboarding or home
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _glowController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OcalmColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              OcalmColors.surface,
              OcalmColors.background,
              OcalmColors.backgroundDarker,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with glow + ring
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Expanding ring
                    AnimatedBuilder2(
                      listenable: _ringController,
                      builder: (context, _) => Transform.scale(
                        scale: _ringExpand.value,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: OcalmColors.primary.withOpacity(_ringFade.value),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Glow behind logo
                    AnimatedBuilder2(
                      listenable: _glowController,
                      builder: (context, _) => Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: OcalmColors.primary.withOpacity(0.25 * _glowPulse.value),
                              blurRadius: 40 * _glowPulse.value,
                              spreadRadius: 5 * _glowPulse.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Logo
                    AnimatedBuilder2(
                      listenable: _logoController,
                      builder: (context, _) => Opacity(
                        opacity: _logoFade.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: OcalmColors.primary.withOpacity(0.1),
                              border: Border.all(color: OcalmColors.primary.withOpacity(0.4), width: 2),
                            ),
                            child: const Icon(
                              Icons.shield_rounded,
                              size: 64,
                              color: OcalmColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // App name
              AnimatedBuilder2(
                listenable: _textController,
                builder: (context, _) => Opacity(
                  opacity: _textFade.value,
                  child: Transform.translate(
                    offset: _textSlide.value,
                    child: Column(
                      children: [
                        const Text(
                          'OCALM',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'SpaceGrotesk',
                            color: OcalmColors.textPrimary,
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Vos paiements sous verrou',
                          style: TextStyle(
                            fontSize: 15,
                            color: OcalmColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
