import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/daily_usage_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/screen_time_service.dart';
import 'package:provider/provider.dart';

class ScreenTimeSettingsScreen extends StatefulWidget {
  const ScreenTimeSettingsScreen({super.key});

  @override
  State<ScreenTimeSettingsScreen> createState() =>
      _ScreenTimeSettingsScreenState();
}

class _ScreenTimeSettingsScreenState extends State<ScreenTimeSettingsScreen> {
  double _limitMinutes = 60;
  int _usedSeconds = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final childId = context.read<AppState>().currentChild?.id;
    if (childId == null) return;
    final db = await AppDatabase.instance.database;
    final repo = DailyUsageRepository(db);
    final limit = await repo.getLimitSeconds(childId);
    final used = await repo.getUsedSeconds(childId);
    if (mounted) {
      setState(() {
        _limitMinutes = (limit / 60).clamp(15, 480);
        _usedSeconds = used;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final childId = context.read<AppState>().currentChild?.id;
    if (childId == null) return;
    final db = await AppDatabase.instance.database;
    final repo = DailyUsageRepository(db);
    await repo.setLimitSeconds(childId, (_limitMinutes * 60).round());
    await context.read<ScreenTimeService>().refreshLimit();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Screen time limit saved!',
              style: TextStyle(fontFamily: 'arlrdbd')),
          backgroundColor: Color(0xFF6DB072),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Screen Time',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⏱ Daily Screen Time Limit',
                    style: TextStyle(fontFamily: 'arlrdbd', fontSize: 20),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      '${_limitMinutes.round()} min',
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 48,
                        color: Color(0xFFF19335),
                      ),
                    ),
                  ),
                  Slider(
                    value: _limitMinutes,
                    min: 15,
                    max: 480,
                    divisions: 31,
                    activeColor: const Color(0xFFF19335),
                    onChanged: (v) => setState(() => _limitMinutes = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('15 min', style: TextStyle(fontFamily: 'arlrdbd')),
                      Text('8 hours', style: TextStyle(fontFamily: 'arlrdbd')),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Today\'s Usage',
                          style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _fmtTime(_usedSeconds),
                          style: const TextStyle(
                            fontFamily: 'arlrdbd',
                            fontSize: 32,
                            color: Color(0xFF6DB072),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF19335),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Save Limit',
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _fmtTime(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}
