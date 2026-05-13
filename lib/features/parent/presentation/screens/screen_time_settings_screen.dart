import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/daily_usage_repository.dart';
import 'package:kids/core/db/children_repository.dart';
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
    final state = context.read<AppState>();
    final childId = state.currentChild?.id;
    if (childId == null) return;
    
    final db = await AppDatabase.instance.database;
    final repo = DailyUsageRepository(db);
    final limit = await repo.getLimitSeconds(childId);
    final used = await repo.getUsedSeconds(childId);
    
    if (mounted) {
      setState(() {
        // Clamp between 15 mins (900s) and 8 hours (28800s)
        _limitMinutes = (limit / 60).clamp(15, 480);
        _usedSeconds = used;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    final childId = state.currentChild?.id;
    if (childId == null) return;

    final db = await AppDatabase.instance.database;
    final repo = DailyUsageRepository(db);
    
    // Save to DB
    final limitSecs = (_limitMinutes.round() * 60);
    await repo.setLimitSeconds(childId, limitSecs);
    
    // Notify service if it's currently tracking this child
    await context.read<ScreenTimeService>().refreshLimit();
    
    if (mounted) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Limit updated for ${state.currentChild?.name}!',
                style: const TextStyle(fontFamily: 'arlrdbd'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final child = state.currentChild;
    final h = _limitMinutes ~/ 60;
    final m = (_limitMinutes % 60).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Screen Time Settings',
          style: TextStyle(
            fontFamily: 'arlrdbd',
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFF19335)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Child Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFF19335).withOpacity(0.1),
                          child: Text(
                            child != null 
                              ? ChildrenRepository.avatarEmojis[child.avatarIndex % ChildrenRepository.avatarEmojis.length]
                              : '👶',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          child?.name ?? 'Select a Child',
                          style: const TextStyle(
                            fontFamily: 'arlrdbd',
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          'Set daily usage limits',
                          style: TextStyle(
                            fontFamily: 'arlrdbd',
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('⏱ Adjust Daily Limit'),
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                h > 0 ? '${h}h ${m}m' : '${m}m',
                                style: const TextStyle(
                                  fontFamily: 'arlrdbd',
                                  fontSize: 42,
                                  color: Color(0xFFF19335),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderThemeData(
                                  activeTrackColor: const Color(0xFFF19335),
                                  inactiveTrackColor: const Color(0xFFF19335).withOpacity(0.1),
                                  thumbColor: const Color(0xFFF19335),
                                  overlayColor: const Color(0xFFF19335).withOpacity(0.1),
                                  valueIndicatorTextStyle: const TextStyle(fontFamily: 'arlrdbd'),
                                ),
                                child: Slider(
                                  value: _limitMinutes,
                                  min: 15,
                                  max: 480, // 8 hours
                                  divisions: 31, // (480-15)/15 = 31 steps
                                  onChanged: (v) {
                                    setState(() => _limitMinutes = v);
                                    HapticFeedback.selectionClick();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('15 min', style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black38, fontSize: 12)),
                                    Text('8 hours', style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black38, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        _buildSectionTitle('📊 Usage Overview'),
                        const SizedBox(height: 16),
                        
                        _usageInfoTile(
                          'Used Today', 
                          _fmtTime(_usedSeconds), 
                          Icons.history_toggle_off_rounded,
                          const Color(0xFF6DB072),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF19335),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontFamily: 'arlrdbd',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'arlrdbd',
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _usageInfoTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 15, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
