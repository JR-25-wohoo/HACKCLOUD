import 'package:flutter/material.dart';
import '../models/word_item.dart';
import '../services/word_loader.dart';

class GameProvider with ChangeNotifier {
  final WordLoader _wordLoader = WordLoader();

  List<WordItem> _words = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _skippedCount = 0; // Add this
  bool _isLoading = false;

  String get currentWord => _words.isEmpty ? '' : _words[_currentIndex].title;
  String get currentDifficulty =>
      _words.isEmpty ? '' : _words[_currentIndex].difficulty;
  int get correctCount => _correctCount;
  int get skippedCount => _skippedCount; // Add this getter
  bool get isLoading => _isLoading;
  bool get hasWords => _words.isNotEmpty;

  Future<void> loadCategory(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _words = await _wordLoader.loadWords(category);
      _words.shuffle();
      _currentIndex = 0;
      _correctCount = 0;
      _skippedCount = 0; // Reset skip count

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void nextWord() {
    if (_words.isEmpty) return;

    _correctCount++;
    _currentIndex++;

    if (_currentIndex >= _words.length) {
      _currentIndex = 0;
      _words.shuffle();
    }

    notifyListeners();
  }

  // Add skip method (for future use)
  void skipWord() {
    if (_words.isEmpty) return;

    _skippedCount++;
    _currentIndex++;

    if (_currentIndex >= _words.length) {
      _currentIndex = 0;
      _words.shuffle();
    }

    notifyListeners();
  }

  void reset() {
    _currentIndex = 0;
    _correctCount = 0;
    _skippedCount = 0;
    notifyListeners();
  }
}
