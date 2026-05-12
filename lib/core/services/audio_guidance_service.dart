import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class AudioGuidanceService {
  AudioGuidanceService._();
  static final AudioGuidanceService instance = AudioGuidanceService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _enabled = true;

  bool get isEnabled => _enabled;
  void setEnabled(bool value) => _enabled = value;

  Future<void> _ensureReady() async {
    if (_ready) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    // Child-friendly high-pitched voice — matches existing app TTS tone.
    await _tts.setPitch(1.4);
    _ready = true;
  }

  Future<void> speak(String text) async {
    if (!_enabled) return;
    try {
      await _ensureReady();
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // TTS engine unavailable on this platform — silently ignore.
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
