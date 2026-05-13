import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/parent_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'parent_dashboard_screen.dart';
import 'package:kids/parent_bottom_nav.dart';
import 'pin_screen.dart';

class ParentZonePage extends StatelessWidget {
  const ParentZonePage({super.key});

  Future<bool> _parentHasPin(int parentId) async {
    final db = await AppDatabase.instance.database;
    final repo = ParentRepository(db);
    final parent = await repo.findById(parentId);
    return parent?.hasPin ?? false;
  }

  Future<void> _enterParentZone(BuildContext context) async {
    final state = context.read<AppState>();
    final parentId = state.parentId;
    if (parentId == null) return;

    final hasPin = await _parentHasPin(parentId);
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PinScreen(isSetup: !hasPin)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    if (state.isParentUnlocked) {
      return const ParentBottomNav();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Color(0xFFF19335)),
            const SizedBox(height: 24),
            const Text(
              'Parent Zone',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 28),
            ),
            const SizedBox(height: 8),
            const Text(
              'Protected with PIN',
              style: TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _enterParentZone(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF19335),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.lock_open, color: Colors.white),
              label: const Text(
                'Enter PIN',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => state.setMode(null),
              child: const Text(
                'Back to Selection',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
