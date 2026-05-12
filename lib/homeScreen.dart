import 'package:flutter/material.dart';
import 'package:kids/Pages/LetsStartLearning.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/features/learning/presentation/screens/activities_menu_screen.dart';
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
            title: const Text(
              'Exit App',
              style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'arlrdbd'),
            ),
            content: const Text(
              'Do you want to exit the App?',
              style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'arlrdbd'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
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
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7F0),
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.28,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.28 - 27,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF7F0),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/sun.png', height: 60),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Hello, ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'arlrdbd',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '$childName! 👋',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'arlrdbd',
                                  color: Color(0xFFF19335),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Let's learn something today!",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'arlrdbd',
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  children: [
                    _modeCard(
                      image: 'assets/images/number.png',
                      label: "Let's Start Learning",
                      color: const Color(0xFFE4F2E6),
                      textColor: const Color(0xFF6DB072),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LetsStartLearning(index),
                        ),
                      ),
                    ),
                    _modeCard(
                      image: 'assets/images/video.png',
                      label: 'Video Learning',
                      color: const Color(0xFFFFF9F4),
                      textColor: const Color(0xFFEC9E4E),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VideoLearning()),
                      ),
                    ),
                    _modeCard(
                      image: 'assets/images/apple.png',
                      label: 'Look And Choose',
                      color: const Color(0xFFFEF9E4),
                      textColor: const Color(0xFFF2CC2B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LookAndChooes(index),
                        ),
                      ),
                    ),
                    _modeCard(
                      image: 'assets/images/lione.png',
                      label: 'Listen and Guess',
                      color: const Color(0xFFEBE8FD),
                      textColor: const Color(0xFF8770E4),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ListenGuess()),
                      ),
                    ),
                    _modeCard(
                      emoji: '🎮',
                      label: 'More Activities',
                      color: const Color(0xFFFFE4E4),
                      textColor: const Color(0xFFE53935),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ActivitiesMenuScreen(),
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

  Widget _modeCard({
    String? image,
    String? emoji,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(image, height: 72)
            else if (emoji != null)
              Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'arlrdbd',
                color: textColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
