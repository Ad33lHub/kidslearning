import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'cosmic_theme.dart';

/// Deep-space gradient + drifting nebula blobs + animated twinkling starfield.
/// Enhanced with vertical drift (top to bottom) for Children's mode.
class CosmicBackground extends StatefulWidget {
  final Widget child;
  final Color accentNebula;
  final bool driftEnabled; // New: enables vertical drift

  const CosmicBackground({
    super.key,
    required this.child,
    this.accentNebula = CosmicPalette.secondaryDeep,
    this.driftEnabled = true, // Default to true as requested
  });

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.4, -0.7),
                radius: 1.4,
                colors: [
                  Color(0xFF2A1A4D),
                  Color(0xFF131315),
                  Color(0xFF0B0B0D),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: _NebulaBlob(
            color: widget.accentNebula.withOpacity(0.35),
            size: 260,
          ),
        ),
        Positioned(
          bottom: 80,
          left: -90,
          child: _NebulaBlob(
            color: CosmicPalette.teal.withOpacity(0.18),
            size: 240,
          ),
        ),
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                painter: _StarfieldPainter(_ctrl.value, widget.driftEnabled),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double radius;
  final double twinkleOffset;
  final double twinkleSpeed;
  final double driftOffset; // For vertical movement

  const _Star(
    this.x,
    this.y,
    this.radius,
    this.twinkleOffset,
    this.twinkleSpeed,
    this.driftOffset,
  );
}

class _StarfieldPainter extends CustomPainter {
  static final List<_Star> _stars = _generate();
  final double t;
  final bool drift;

  _StarfieldPainter(this.t, this.drift);

  static List<_Star> _generate() {
    final rng = math.Random(7);
    return List.generate(64, (_) {
      return _Star(
        rng.nextDouble(),
        rng.nextDouble(),
        rng.nextDouble() * 1.6 + 0.4,
        rng.nextDouble(),
        rng.nextDouble() * 0.8 + 0.4,
        rng.nextDouble(), // Random offset for drift
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final s in _stars) {
      // Calculate twinkling
      final phase = (t * s.twinkleSpeed + s.twinkleOffset) % 1.0;
      final tw = 0.45 + 0.55 * (math.sin(phase * math.pi * 2) * 0.5 + 0.5);
      
      // Calculate Y position with top-to-bottom drift
      double yPos = s.y;
      if (drift) {
        // Vertical movement: (y + t) % 1.0 makes it wrap around
        yPos = (s.y + t) % 1.0;
      }

      paint.color = Colors.white.withOpacity(0.18 + 0.55 * tw);
      canvas.drawCircle(
        Offset(s.x * size.width, yPos * size.height),
        s.radius * (0.8 + 0.4 * tw),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter old) => old.t != t || old.drift != drift;
}

class _NebulaBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _NebulaBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}
