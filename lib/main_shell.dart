import 'package:flutter/material.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/screen_time_service.dart';
import 'package:kids/features/parent/presentation/screens/times_up_screen.dart';
import 'package:kids/core/services/background_music_service.dart';
import 'package:provider/provider.dart';

import 'bottomnavigation.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_startTracking);
  }

  Future<void> _startTracking() async {
    final childId = context.read<AppState>().currentChild?.id;
    if (childId != null) {
      await context.read<ScreenTimeService>().startTracking(childId);
    }
    // Start background music for children's mode
    BackgroundMusicService.instance.play();
  }

  @override
  void dispose() {
    // Stop music when leaving children's mode
    BackgroundMusicService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final limitReached = context.watch<ScreenTimeService>().limitReached;
    if (limitReached) return const TimesUpScreen();
    return const BottomNav();
  }
}
