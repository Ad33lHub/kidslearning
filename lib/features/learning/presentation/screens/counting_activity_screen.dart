import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/quiz_completion_service.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class CountingActivityScreen extends StatefulWidget {
  const CountingActivityScreen({super.key});

  @override
  State<CountingActivityScreen> createState() => _CountingActivityScreenState();
}

class _CountingActivityScreenState extends State<CountingActivityScreen> {
  final FlutterTts _tts = FlutterTts();
  final _rng = Random();
  int _count = 1;
  late List<int> _options;
  int? _selected;
  int _score = 0;
  int _total = 0;
  bool _saving = false;

  static const _minQuestionsBeforeDone = 5;
  static const _animals = ['🐶', '🐱', '🐸', '🦋', '⭐', '🍎', '🌻', '🐘'];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('en-US');
    _tts.setPitch(1.5);
    _newQuestion();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _newQuestion() {
    _count = _rng.nextInt(10) + 1;
    final correct = _count;
    final opts = <int>{correct};
    while (opts.length < 4) {
      opts.add(_rng.nextInt(10) + 1);
    }
    _options = opts.toList()..shuffle();
    _selected = null;
  }

  void _onSelect(int val) {
    if (_selected != null) return;
    setState(() {
      _selected = val;
      _total++;
      if (val == _count) {
        _score++;
        _tts.speak('Correct! $_count');
      } else {
        _tts.speak('Try again! The answer is $_count');
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _newQuestion());
    });
  }

  Future<void> _finish() async {
    if (_total == 0 || _saving) return;
    setState(() => _saving = true);
    final childId = context.read<AppState>().currentChild?.id;
    final result = await QuizCompletionService.instance.record(
      childId: childId,
      category: 'numbers',
      score: _score,
      total: _total,
    );
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ResultDialog(
        score: result.score,
        total: result.total,
        stars: result.starsAwarded,
        coins: result.coinsAwarded,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final canFinish = _total >= _minQuestionsBeforeDone;
    final emoji = _animals[_count % _animals.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            backgroundColor: const Color(0xFF1D4ED8),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Counting Fun',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientNumbers,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$_score / $_total',
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'How many do you see?',
                    style: TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 22,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientNumbers.last
                                .withOpacity(0.20),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          _count,
                          (_) => Text(
                            emoji,
                            style: TextStyle(
                              fontSize:
                                  _count <= 5 ? 56 : _count <= 8 ? 44 : 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: _options.map((opt) {
                      Color bgColor = Colors.white;
                      Color borderColor = AppColors.primaryLight;
                      if (_selected != null) {
                        if (opt == _count) {
                          bgColor = AppColors.success;
                          borderColor = AppColors.success;
                        } else if (opt == _selected) {
                          bgColor = AppColors.error;
                          borderColor = AppColors.error;
                        }
                      }
                      return GestureDetector(
                        onTap: () => _onSelect(opt),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: borderColor.withOpacity(0.20),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$opt',
                              style: TextStyle(
                                fontFamily: 'arlrdbd',
                                fontSize: 28,
                                color: _selected != null &&
                                        (opt == _count || opt == _selected)
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (canFinish)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                        ),
                        onPressed: _saving ? null : _finish,
                        child: _saving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text(
                                '🏁  I\'m Done!',
                                style: TextStyle(
                                  fontFamily: 'arlrdbd',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                if (!canFinish)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '${_minQuestionsBeforeDone - _total} more to unlock finish',
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final int score;
  final int total;
  final int stars;
  final int coins;

  const _ResultDialog({
    required this.score,
    required this.total,
    required this.stars,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (score / total * 100).round() : 0;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        '🎉 Great Counting!',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'arlrdbd', fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.gradientNumbers,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '$score / $total',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$pct% correct',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _rewardChip('⭐', '+$stars Stars', AppColors.gradientRewards),
              const SizedBox(width: 12),
              _rewardChip('🪙', '+$coins Coins', AppColors.gradientActivities),
            ],
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Done',
              style: TextStyle(
                fontFamily: 'arlrdbd',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rewardChip(String emoji, String label, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
