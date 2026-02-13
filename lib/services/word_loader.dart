import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word_item.dart';

class WordLoader {
  // Load all words from a category
  Future<List<WordItem>> loadWords(String category) async {
    final String response = await rootBundle.loadString(
      'assets/data/$category.json',
    );
    final Map<String, dynamic> data = json.decode(response);

    // Get the array from the category key
    final List<dynamic> wordsJson = data[category] as List<dynamic>;

    return wordsJson.map((json) => WordItem.fromJson(json)).toList();
  }

  // Load words filtered by difficulty (for future use)
  Future<List<WordItem>> loadWordsByDifficulty(
    String category,
    String difficulty,
  ) async {
    final allWords = await loadWords(category);
    return allWords.where((word) => word.difficulty == difficulty).toList();
  }

  // Load words with mixed difficulties (for future use)
  Future<List<WordItem>> loadWordsMixed(
    String category,
    List<String> difficulties,
  ) async {
    final allWords = await loadWords(category);
    return allWords
        .where((word) => difficulties.contains(word.difficulty))
        .toList();
  }
}
