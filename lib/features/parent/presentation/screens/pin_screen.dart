import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/parent_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup;
  const PinScreen({super.key, this.isSetup = false});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _confirming = false;
  String? _error;

  void _onDigit(String digit) {
    setState(() => _error = null);
    if (!_confirming) {
      if (_pin.length < 4) {
        setState(() => _pin += digit);
        if (_pin.length == 4) {
          if (widget.isSetup) {
            setState(() => _confirming = true);
          } else {
            _verify();
          }
        }
      }
    } else {
      if (_confirmPin.length < 4) {
        setState(() => _confirmPin += digit);
        if (_confirmPin.length == 4) _setupPin();
      }
    }
  }

  void _onDelete() {
    setState(() {
      if (_confirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  Future<void> _verify() async {
    final parentId = context.read<AppState>().parentId;
    if (parentId == null) return;
    final db = await AppDatabase.instance.database;
    final repo = ParentRepository(db);
    final ok = await repo.verifyPin(parentId: parentId, pin: _pin);
    if (!mounted) return;
    if (ok) {
      context.read<AppState>().unlockParent();
      Navigator.pop(context, true);
    } else {
      setState(() {
        _pin = '';
        _error = 'Incorrect PIN. Try again.';
      });
    }
  }

  Future<void> _setupPin() async {
    if (_pin != _confirmPin) {
      setState(() {
        _confirmPin = '';
        _error = 'PINs do not match. Try again.';
        _confirming = false;
        _pin = '';
      });
      return;
    }
    final parentId = context.read<AppState>().parentId;
    if (parentId == null) return;
    final db = await AppDatabase.instance.database;
    final repo = ParentRepository(db);
    await repo.setPin(parentId: parentId, pin: _pin);
    if (!mounted) return;
    context.read<AppState>().unlockParent();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final current = _confirming ? _confirmPin : _pin;
    final title = widget.isSetup
        ? (_confirming ? 'Confirm PIN' : 'Set a 4-Digit PIN')
        : 'Enter Parent PIN';

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 60, color: Color(0xFFF19335)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 20),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < current.length
                      ? const Color(0xFFF19335)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontFamily: 'arlrdbd'),
            ),
          ],
          const SizedBox(height: 40),
          _numPad(),
        ],
      ),
    );
  }

  Widget _numPad() {
    final digits = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'DEL'],
    ];
    return Column(
      children: digits
          .map(
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((d) {
                if (d.isEmpty) return const SizedBox(width: 80, height: 72);
                return GestureDetector(
                  onTap: () => d == 'DEL' ? _onDelete() : _onDigit(d),
                  child: Container(
                    width: 80,
                    height: 72,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: d == 'DEL' ? Colors.grey.shade200 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: d == 'DEL'
                          ? const Icon(Icons.backspace_outlined, size: 24)
                          : Text(
                              d,
                              style: const TextStyle(
                                fontFamily: 'arlrdbd',
                                fontSize: 26,
                                color: Colors.black87,
                              ),
                            ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
          .toList(),
    );
  }
}
