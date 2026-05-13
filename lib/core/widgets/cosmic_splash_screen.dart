import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_background.dart';
import 'package:kids/core/widgets/cosmic_theme.dart';

class CosmicSplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const CosmicSplashScreen({super.key, required this.onFinish});

  @override
  State<CosmicSplashScreen> createState() => _CosmicSplashScreenState();
}

class _CosmicSplashScreenState extends State<CosmicSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scale = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.elasticOut,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );

    _logoCtrl.forward();

    // Splash duration 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) widget.onFinish();
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicPalette.bg,
      body: CosmicBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: FadeTransition(
                  opacity: _opacity,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      boxShadow: [
                        BoxShadow(
                          color: CosmicPalette.secondary.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 90,
                        errorBuilder: (_, __, ___) => const Text(
                          '🚀',
                          style: TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _opacity,
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [CosmicPalette.secondary, Colors.white],
                      ).createShader(bounds),
                      child: const Text(
                        'KIDS LEARNING',
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: 32,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore the Universe of Knowledge',
                      style: CosmicText.caption.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: CosmicPalette.secondary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
