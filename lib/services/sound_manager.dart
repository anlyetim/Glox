import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

/// Sound manager with working audio playback
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _tapPlayer = AudioPlayer();
  final AudioPlayer _winPlayer = AudioPlayer();
  final Random _random = Random();
  
  bool _isMuted = false;
  bool _initialized = false;

  bool get isMuted => _isMuted;
  bool get isInitialized => _initialized;

  /// Initialize sound system
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      print('🔊 Initializing sound system...');
      
      // Configure players for low latency
      await _tapPlayer.setReleaseMode(ReleaseMode.stop);
      await _tapPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _tapPlayer.setVolume(0.7);
      
      await _winPlayer.setReleaseMode(ReleaseMode.stop);
      await _winPlayer.setVolume(0.8);
      
      _initialized = true;
      print('✅ Sound system initialized');
    } catch (e) {
      print('❌ Sound system failed: $e');
      _initialized = false;
    }
  }

  /// Play random tap sound (Pop1-4.wav)
  Future<void> playTapSound() async {
    if (!_initialized || _isMuted) return;
    
    try {
      // Pick random pop sound (1-4)
      final popNumber = _random.nextInt(4) + 1;
      final soundPath = 'sounds/Pop$popNumber.wav';
      
      // Stop current sound and play new one
      await _tapPlayer.stop();
      await _tapPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('⚠️ Failed to play tap sound: $e');
    }
  }

  /// Play win sound
  Future<void> playWinSound() async {
    if (!_initialized || _isMuted) return;
    
    try {
      await _winPlayer.stop();
      await _winPlayer.play(AssetSource('sounds/Win.wav'));
    } catch (e) {
      print('⚠️ Failed to play win sound: $e');
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    print('🔊 Muted: $_isMuted');
  }

  void setMuted(bool muted) {
    _isMuted = muted;
  }

  Future<void> dispose() async {
    await _tapPlayer.dispose();
    await _winPlayer.dispose();
  }
}
