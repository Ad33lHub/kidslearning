import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/audio_guidance_service.dart';
import 'package:kids/core/services/background_music_service.dart';
import 'package:kids/features/learning/presentation/screens/activities_menu_screen.dart';
import 'package:kids/features/learning/presentation/screens/rewards_screen.dart';
import 'package:kids/core/services/screen_time_service.dart';
import 'package:kids/features/learning/presentation/screens/child_settings_screen.dart';
import 'package:kids/features/learning/presentation/screens/video_learning_screen.dart';
import 'package:provider/provider.dart';

import 'Pages/LookAndChooes.dart';
import 'Pages/listen_and_guess.dart';

// Cosmic Discovery palette — see DESIGN.md
const Color _cosmicBg = Color(0xFF0E0E10);
const Color _cosmicSurface = Color(0xFF201F21);
const Color _cosmicOutline = Color(0x33FFFFFF);
const Color _cosmicPrimary = Color(0xFFC1C5E3);
const Color _cosmicSecondary = Color(0xFFEBB2FF);
const Color _cosmicSecondaryDeep = Color(0xFFB600F8);
const Color _cosmicTertiary = Color(0xFFC9CE00);
const Color _cosmicTeal = Color(0xFF7FE7D4);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _starsCtrl;
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _starsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _starsCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  Future<bool> _showExitPopup() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _cosmicSurface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _cosmicOutline, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Exit mission?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'arlrdbd',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Are you sure you want to leave the cosmos?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFC7C5CE),
                          fontSize: 15,
                          fontFamily: 'arlrdbd',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: _cosmicOutline,
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text(
                                'Stay',
                                style: TextStyle(
                                  fontFamily: 'arlrdbd',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _cosmicSecondaryDeep,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text(
                                'Exit',
                                style: TextStyle(
                                  fontFamily: 'arlrdbd',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<void> _onModeTap(dynamic navResult, String spoken) async {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
    // Pause background music for activity
    await BackgroundMusicService.instance.pause();
    // Fire and forget — TTS unavailable on some platforms.
    AudioGuidanceService.instance.speak(spoken);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    
    // Wait for the activity screen to close
    if (navResult is Future) {
      await navResult;
    }
    
    // Resume background music when returning to home
    await BackgroundMusicService.instance.resume();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final child = context.watch<AppState>().currentChild;
    final childName = child?.name ?? 'Explorer';

    final modes = <_ModeData>[
      _ModeData(
        image: 'assets/images/number.png',
        label: "Let's start\nlearning",
        accent: _cosmicSecondary,
        glow: _cosmicSecondaryDeep,
        emojiCorner: '🪐',
        spoken: "Let's start learning",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LetsStartLearning(0),
          ),
        ),
      ),
      _ModeData(
        image: 'assets/images/apple.png',
        label: 'Look and\nchoose',
        accent: _cosmicPrimary,
        glow: const Color(0xFF585D77),
        emojiCorner: '🌟',
        spoken: 'Look and choose',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LookAndChooes(0)),
        ),
      ),
      _ModeData(
        image: 'assets/images/lione.png',
        label: 'Listen and\nguess',
        accent: _cosmicTertiary,
        glow: const Color(0xFF7F8200),
        emojiCorner: '☄️',
        spoken: 'Listen and guess',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ListenGuess()),
        ),
      ),
      _ModeData(
        emoji: '🎮',
        label: 'More\nactivities',
        accent: const Color(0xFFFF8FB1),
        glow: const Color(0xFFFF4D8D),
        emojiCorner: '🚀',
        spoken: 'More activities',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ActivitiesMenuScreen(),
          ),
        ),
      ),
      _ModeData(
        emoji: '🏆',
        label: 'My\nrewards',
        accent: _cosmicTertiary,
        glow: const Color(0xFFC9CE00),
        emojiCorner: '✨',
        spoken: 'My rewards',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RewardsScreen()),
        ),
      ),
      _ModeData(
        emoji: '📺',
        label: 'Video\nLearning',
        accent: const Color(0xFFFFD1A4),
        glow: const Color(0xFFFF8A00),
        emojiCorner: '🎬',
        spoken: 'Video Learning',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VideoLearningScreen()),
        ),
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await _showExitPopup();
        if (shouldExit && context.mounted) {
          context.read<AppState>().setMode(null);
        }
      },
      child: Scaffold(
        backgroundColor: _cosmicBg,
        body: Stack(
          children: [
            // Deep space gradient
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
            // Drifting nebula blobs
            Positioned(
              top: -80,
              right: -60,
              child: _NebulaBlob(
                color: _cosmicSecondaryDeep.withOpacity(0.35),
                size: 260,
              ),
            ),
            Positioned(
              bottom: 80,
              left: -90,
              child: _NebulaBlob(
                color: _cosmicTeal.withOpacity(0.18),
                size: 240,
              ),
            ),
            // Animated starfield — RepaintBoundary isolates repaints
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _starsCtrl,
                  builder: (_, __) => CustomPaint(
                    painter: _StarfieldPainter(_starsCtrl.value),
                  ),
                ),
              ),
            ),
            // Foreground
            SafeArea(
              child: Column(
                children: [
                  _CosmicHeader(
                    size: size,
                    childName: childName,
                    floatCtrl: _floatCtrl,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: modes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.92,
                        ),
                        itemBuilder: (context, i) {
                          final m = modes[i];
                            return _GlassModeCard(
                              data: m,
                              floatCtrl: _floatCtrl,
                              phase: i * 0.18,
                              onTap: () => _onModeTap(m.onTap(), m.spoken),
                            );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Cosmic header (glassmorphism greeting card with floating logo)
// ─────────────────────────────────────────────────────────────────────────────

class _CosmicHeader extends StatelessWidget {
  final Size size;
  final String childName;
  final AnimationController floatCtrl;

  const _CosmicHeader({
    required this.size,
    required this.childName,
    required this.floatCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final child = appState.currentChild;
    final stars = appState.stars;
    final coins = appState.coins;
    final screenTime = context.watch<ScreenTimeService>();

    final List<String> avatars = [
      '🐙', '🦁', '🐼', '🐯', '🦊', '🐻', '🐸', '🦄', '🐱', '🐶', '🦉', '🐧'
    ];
    final avatar = avatars[child?.avatarIndex ?? 0];
    final ageText = child?.age != null ? 'Age ${child!.age} • ' : '';
    final levelText = child?.level.toUpperCase() ?? 'EXPLORER';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with float animation
              AnimatedBuilder(
                animation: floatCtrl,
                builder: (_, child) {
                  final dy = math.sin(floatCtrl.value * math.pi * 2) * 3;
                  return Transform.translate(
                    offset: Offset(0, dy),
                    child: child,
                  );
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A1A4D), Color(0xFF131315)],
                    ),
                    border: Border.all(color: _cosmicOutline, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    avatar,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and Age/Level
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      childName.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '$ageText$levelText',
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 12,
                        color: Color(0xFFC7C5CE),
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              _GlassPill(
                label: '$stars',
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
              ),
              const SizedBox(width: 8),
              // Coins
              _GlassPill(
                label: '$coins',
                icon: Icons.monetization_on_rounded,
                iconColor: const Color(0xFFFFD700),
              ),
              const SizedBox(width: 8),
              // Settings Gear
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChildSettingsScreen()),
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: _cosmicOutline),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Color(0xFFC1C5E3),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Screen Time Progress Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Screen Time',
                    style: TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 12,
                      color: Color(0xFFC7C5CE),
                    ),
                  ),
                  Text(
                    '${screenTime.remainingFormatted} left',
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 12,
                      color: Color(0xFF7FE7D4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 1.0 - screenTime.progress, // Showing remaining time as green
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  final String? label;
  final IconData icon;
  final Color iconColor;

  const _GlassPill({
    this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: label == null ? 10 : 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cosmicOutline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glass mode card with float + press animation
// ─────────────────────────────────────────────────────────────────────────────

class _ModeData {
  final String? image;
  final String? emoji;
  final String label;
  final Color accent;
  final Color glow;
  final String emojiCorner;
  final String spoken;
  final Function onTap;

  const _ModeData({
    this.image,
    this.emoji,
    required this.label,
    required this.accent,
    required this.glow,
    required this.emojiCorner,
    required this.spoken,
    required this.onTap,
  });
}

class _GlassModeCard extends StatefulWidget {
  final _ModeData data;
  final AnimationController floatCtrl;
  final double phase;
  final VoidCallback onTap;

  const _GlassModeCard({
    required this.data,
    required this.floatCtrl,
    required this.phase,
    required this.onTap,
  });

  @override
  State<_GlassModeCard> createState() => _GlassModeCardState();
}

class _GlassModeCardState extends State<_GlassModeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return AnimatedBuilder(
      animation: widget.floatCtrl,
      builder: (_, child) {
        final dy = math.sin(
              (widget.floatCtrl.value + widget.phase) * math.pi * 2,
            ) *
            4;
        return Transform.translate(
          offset: Offset(0, dy),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: d.glow.withOpacity(_pressed ? 0.55 : 0.30),
                  blurRadius: _pressed ? 22 : 16,
                  spreadRadius: _pressed ? 1 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        d.accent.withOpacity(0.22),
                        Colors.white.withOpacity(0.04),
                      ],
                    ),
                    border: Border.all(color: _cosmicOutline, width: 1),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Text(
                          d.emojiCorner,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: d.accent.withOpacity(0.12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    d.accent.withOpacity(0.55),
                                    d.accent.withOpacity(0.10),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: d.glow.withOpacity(0.55),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                              child: d.image != null
                                  ? Image.asset(
                                      d.image!,
                                      height: 48,
                                      fit: BoxFit.contain,
                                    )
                                  : Text(
                                      d.emoji!,
                                      style: const TextStyle(fontSize: 36),
                                    ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              d.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'arlrdbd',
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Background flair: starfield painter + nebula blobs
// ─────────────────────────────────────────────────────────────────────────────

class _Star {
  final double x;
  final double y;
  final double radius;
  final double twinkleOffset;
  final double twinkleSpeed;
  const _Star(
    this.x,
    this.y,
    this.radius,
    this.twinkleOffset,
    this.twinkleSpeed,
  );
}

class _StarfieldPainter extends CustomPainter {
  static final List<_Star> _stars = _generate();
  final double t;

  _StarfieldPainter(this.t);

  static List<_Star> _generate() {
    final rng = math.Random(7);
    return List.generate(64, (_) {
      return _Star(
        rng.nextDouble(),
        rng.nextDouble(),
        rng.nextDouble() * 1.6 + 0.4,
        rng.nextDouble(),
        rng.nextDouble() * 0.8 + 0.4,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (final s in _stars) {
      final phase = (t * s.twinkleSpeed + s.twinkleOffset) % 1.0;
      final tw = 0.45 + 0.55 * (math.sin(phase * math.pi * 2) * 0.5 + 0.5);
      paint.color = Colors.white.withOpacity(0.18 + 0.55 * tw);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.radius * (0.8 + 0.4 * tw),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter old) => old.t != t;
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
