import 'package:flutter/material.dart';

/// Animations OCALM — Afro-Futuriste
/// Courbes fluides, stagger delays, glow pulses
class OcalmAnimations {
  OcalmAnimations._();

  // ─── Durées ───────────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration pageTransition = Duration(milliseconds: 400);
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // ─── Courbes ──────────────────────────────────────────────────────
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve entryCurve = Curves.easeOutBack;
  static const Curve exitCurve = Curves.easeInCubic;

  // ─── Page Route avec slide + fade ─────────────────────────────────
  static Route<T> slideRoute<T>(Widget page, {Offset begin = const Offset(1.0, 0.0)}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: pageTransition,
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(begin: begin, end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: defaultCurve));
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.6)));
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }

  // ─── Fade + Scale route ───────────────────────────────────────────
  static Route<T> fadeScaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: pageTransition,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleAnimation = Tween<double>(begin: 0.92, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: defaultCurve));
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.7)));
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }
}

/// Widget qui anime ses enfants avec un stagger effect
class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration itemDuration;
  final Offset slideOffset;
  final CrossAxisAlignment crossAxisAlignment;

  const StaggeredList({
    super.key,
    required this.children,
    this.delay = Duration.zero,
    this.itemDuration = const Duration(milliseconds: 400),
    this.slideOffset = const Offset(0, 20),
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(vsync: this, duration: widget.itemDuration),
    );
    _fadeAnimations = _controllers.map((c) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: OcalmAnimations.defaultCurve),
      ),
    ).toList();
    _slideAnimations = _controllers.map((c) =>
      Tween<Offset>(begin: widget.slideOffset, end: Offset.zero).animate(
        CurvedAnimation(parent: c, curve: OcalmAnimations.defaultCurve),
      ),
    ).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(widget.delay);
    for (int i = 0; i < _controllers.length; i++) {
      if (!mounted) return;
      _controllers[i].forward();
      if (i < _controllers.length - 1) {
        await Future.delayed(OcalmAnimations.staggerDelay);
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: List.generate(widget.children.length, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimations[i].value,
              child: Transform.translate(
                offset: _slideAnimations[i].value,
                child: widget.children[i],
              ),
            );
          },
        );
      }),
    );
  }
}

/// Animated builder helper
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({super.key, required this.animation, required this.builder});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: animation,
      builder: builder,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder2({super.key, required super.listenable, required this.builder});

  @override
  Widget build(BuildContext context) => builder(context, null);
}

/// Pulse glow animation widget
class PulseGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double maxRadius;
  final Duration duration;

  const PulseGlow({
    super.key,
    required this.child,
    required this.glowColor,
    this.maxRadius = 30,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.3 * _animation.value),
                blurRadius: widget.maxRadius * _animation.value,
                spreadRadius: 5 * _animation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Fade-in widget on first build
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideOffset;

  const FadeInWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.slideOffset = const Offset(0, 15),
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: OcalmAnimations.defaultCurve),
    );
    _slideAnimation = Tween<Offset>(begin: widget.slideOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: OcalmAnimations.defaultCurve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Shimmer loading effect for cards
class ShimmerCard extends StatefulWidget {
  final double height;
  final double borderRadius;

  const ShimmerCard({super.key, this.height = 80, this.borderRadius = 16});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-1.0 + 2.0 * _controller.value + 1, 0),
              colors: const [
                Color(0xFF241845),
                Color(0xFF2E2055),
                Color(0xFF241845),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated counter for numbers (e.g. wallet balance)
class AnimatedCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final String suffix;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.suffix = ' FCFA',
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: _animation.value, end: widget.value.toDouble()).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      listenable: _animation,
      builder: (context, child) {
        final formatted = _animation.value.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
        return Text('$formatted${widget.suffix}', style: widget.style);
      },
    );
  }
}
