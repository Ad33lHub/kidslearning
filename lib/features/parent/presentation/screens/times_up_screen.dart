import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/parent_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/screen_time_service.dart';
import 'package:provider/provider.dart';

import 'pin_screen.dart';

class TimesUpScreen extends StatelessWidget {
  const TimesUpScreen({super.key});

  Future<void> _unlockWithPin(BuildContext context) async {
    final state = context.read<AppState>();
    final parentId = state.parentId;
    if (parentId == null) return;

    final db = await AppDatabase.instance.database;
    final repo = ParentRepository(db);
    final parent = await repo.findById(parentId);
    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinScreen(isSetup: !(parent?.hasPin ?? false)),
      ),
    );

    if (context.mounted && context.read<AppState>().isParentUnlocked) {
      context.read<ScreenTimeService>().resetLimit();
      context.read<AppState>().lockParent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⏰', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text(
                "Time's Up!",
                style: TextStyle(fontFamily: 'arlrdbd', fontSize: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                "Great learning today!\nCome back tomorrow for more fun.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => _unlockWithPin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.lock, color: Colors.white, size: 18),
                label: const Text(
                  'Parent Access',
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    color: Colors.white,
                    fontSize: 16,
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
