import 'package:flutter_tts/flutter_tts.dart';

import '../../utilities/console_logger.dart';

/// Thin wrapper around [FlutterTts] for speaking Japanese text.
class TtsService {
  TtsService() {
    _configure();
  }

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _configure() async {
    try {
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(0.45);
      await _tts.awaitSpeakCompletion(true);
      _ready = true;
    } catch (e) {
      cw('TTS configure failed: $e');
    }
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    try {
      if (!_ready) await _configure();

      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      cw('TTS speak failed: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
