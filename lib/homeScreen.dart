import 'package:flutter/material.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:kids/core/theme/app_text_styles.dart';
import 'package:kids/features/learning/presentation/screens/activities_menu_screen.dart';
import 'package:kids/features/learning/presentation/screens/rewards_screen.dart';
import 'package:provider/provider.dart';

import 'Pages/LookAndChooes.dart';
import 'Pages/VideoLearning.dart';
import 'Pages/listen_and_guess.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  Future<bool> _showExitPopup() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              'Exit App',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontFamily: 'arlrdbd',
              ),
            ),
            content: const Text(
              'Do you want to exit the App?',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontFamily: 'arlrdbd',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final child = context.watch<AppState>().currentChild;
    final childName = child?.name ?? 'Explorer';

    return WillPopScope(
      onWillPop: _showExitPopup,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _HomeHeader(size: size, childName: childName),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [
                    _ModeCard(
                      image: 'assets/images/number.png',
                      label: "Let's Start\nLearning",
                      gradient: AppColors.gradientLearning,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LetsStartLearning(index),
                        ),
                      ),
                    ),
                    _ModeCard(
                      image: 'assets/images/video.png',
                      label: 'Video\nLearning',
                      gradient: AppColors.gradientVideo,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VideoLearning(),
                        ),
                      ),
                    ),
                    _ModeCard(
                      image: 'assets/images/apple.png',
                      label: 'Look And\nChoose',
                      gradient: AppColors.gradientQuiz,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LookAndChooes(index),
                        ),
                      ),
                    ),
                    _ModeCard(
                      image: 'assets/images/lione.png',
                      label: 'Listen And\nGuess',
                      gradient: AppColors.gradientListen,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ListenGuess(),
                        ),
                      ),
                    ),
                    _ModeCard(
                      emoji: '🎮',
                      label: 'More\nActivities',
                      gradient: AppColors.gradientActivities,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ActivitiesMenuScreen(),
                        ),
                      ),
                    ),
                    _ModeCard(
                      emoji: '🏆',
                      label: 'My\nRewards',
                      gradient: AppColors.gradientRewards,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RewardsScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final Size size;
  final String childName;

  const _HomeHeader({required this.size, required this.childName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.30,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(44),
          bottomRight: Radius.circular(44),
        ),
      ),
      child: Stack(
        children: [
          _DecorativeCircle(top: -30, right: -25, size: 130, opacity: 0.15),
          _DecorativeCircle(top: 45, right: 65, size: 55, opacity: 0.10),
          _DecorativeCircle(bottom: 10, left: -35, size: 110, opacity: 0.10),
          _DecorativeCircle(bottom: -10, right: 40, size: 70, opacity: 0.07),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.child_care_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              'Level Up!',
                              style: TextStyle(
                                fontFamily: 'arlrdbd',
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/logo.png', height: 64),
                  const SizedBox(height: 6),
                  Text(
                    'Hello, $childName! 🌟',
                    style: AppTextStyles.greetingName,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "What shall we learn today?",
                    style: AppTextStyles.greetingSub,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double opacity;

  const _DecorativeCircle({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String? image;
  final String? emoji;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ModeCard({
    this.image,
    this.emoji,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -18,
              right: -18,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -12,
              left: -12,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                  ),
                  child: image != null
                      ? Image.asset(image!, height: 52, fit: BoxFit.contain)
                      : Text(
                          emoji!,
                          style: const TextStyle(fontSize: 40),
                        ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
