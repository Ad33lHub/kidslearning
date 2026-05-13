import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicService {
  BackgroundMusicService._();
  static final BackgroundMusicService instance = BackgroundMusicService._();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  Future<void> play() async {
    if (_isPlaying) return;
    try {
      // Set the source to the background music file in assets
      await _player.setSource(AssetSource('audio/background_music.mp3'));
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_isMuted ? 0 : 0.4); // Apply mute state
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      print('Background music error: $e');
      // If file doesn't exist yet, we silently ignore to prevent crashes
    }
  }

  Future<void> stop() async {
    if (!_isPlaying) return;
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> pause() async {
    if (!_isPlaying) return;
    await _player.pause();
    _isPlaying = false; // MUST set to false so resume() can work
  }

  Future<void> resume() async {
    if (_isPlaying) return;
    await _player.resume();
    _isPlaying = true;
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _player.setVolume(_isMuted ? 0 : 0.4);
    // If we were muted and unmuted, ensure we are playing if we should be
    if (!_isMuted && !_isPlaying) {
      // Note: We don't force resume here because we might be in a tab where music should stay paused
    }
  }
}
