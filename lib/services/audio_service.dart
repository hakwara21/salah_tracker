import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final List<AudioPlayer> _preloadedPlayers = [];
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _player.setAudioSource(
        ConcatenatingAudioSource(
          children: [
            AudioSource.asset('assets/Sounds/Azan/Azhan1.mp3'),
            AudioSource.asset('assets/Sounds/Azan/Azhan2.mp3'),
            AudioSource.asset('assets/Sounds/Azan/Azhan3.mp3'),
            AudioSource.asset('assets/Sounds/Azan/Azhan4.mp3'),
          ],
        ),
        preload: true,
      );
    } catch (e) {
      // Ignore preload errors
    }

    _isInitialized = true;
  }

  Future<void> playAzan(String soundName) async {
    try {
      final assetPath = 'assets/Sounds/Azan/$soundName.mp3';
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      // Fallback to system sound or ignore
    }
  }

  Future<void> playAzanFromAsset(String assetPath) async {
    try {
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> stopAzan() async {
    await _player.stop();
  }

  Future<void> pauseAzan() async {
    await _player.pause();
  }

  Future<void> resumeAzan() async {
    await _player.play();
  }

  bool get isPlaying => _player.playing;

  Stream<bool> get playingStream => _player.playingStream;

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> dispose() async {
    // Dispose preloaded players
    for (final player in _preloadedPlayers) {
      await player.dispose();
    }
    _preloadedPlayers.clear();

    // Dispose main player
    await _player.dispose();
    _isInitialized = false;
  }

  Future<void> preloadAzanSounds() async {
    // Clear any existing preloaded players
    for (final player in _preloadedPlayers) {
      await player.dispose();
    }
    _preloadedPlayers.clear();

    try {
      for (int i = 1; i <= 4; i++) {
        final player = AudioPlayer();
        await player.setAsset('assets/Sounds/Azan/Azhan$i.mp3');
        _preloadedPlayers.add(player);
      }
    } catch (e) {
      // Ignore preload errors
    }
  }
}
