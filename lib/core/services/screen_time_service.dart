import 'dart:async';

import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../db/daily_usage_repository.dart';

class ScreenTimeService extends ChangeNotifier {
  Timer? _timer;
  int _childId = 0;
  int _usedSeconds = 0;
  int _limitSeconds = 3600;
  bool _limitReached = false;
  DailyUsageRepository? _repo;

  int get usedSeconds => _usedSeconds;
  int get limitSeconds => _limitSeconds;
  bool get limitReached => _limitReached;

  int get remainingSeconds => (_limitSeconds - _usedSeconds).clamp(0, _limitSeconds);
  double get progress => (_usedSeconds / _limitSeconds).clamp(0.0, 1.0);

  String get usedFormatted => _fmt(_usedSeconds);
  String get limitFormatted => _fmt(_limitSeconds);
  String get remainingFormatted => _fmt(remainingSeconds);

  Future<void> startTracking(int childId) async {
    _childId = childId;
    final db = await AppDatabase.instance.database;
    _repo = DailyUsageRepository(db);
    _usedSeconds = await _repo!.getUsedSeconds(childId);
    _limitSeconds = await _repo!.getLimitSeconds(childId);
    _limitReached = _usedSeconds >= _limitSeconds;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), _tick);
  }

  Future<void> _tick(Timer _) async {
    if (_limitReached || _repo == null) return;
    await _repo!.addSeconds(_childId, 10);
    _usedSeconds += 10;
    if (_usedSeconds >= _limitSeconds) {
      _limitReached = true;
    }
    notifyListeners();
  }

  Future<void> refreshLimit() async {
    if (_repo == null) return;
    _limitSeconds = await _repo!.getLimitSeconds(_childId);
    _limitReached = _usedSeconds >= _limitSeconds;
    notifyListeners();
  }

  void resetLimit() {
    _limitReached = false;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  static String _fmt(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
