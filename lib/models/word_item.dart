class WordItem {
  final String title;
  final String difficulty;

  WordItem({
    required this.title,
    required this.difficulty,
  });

  factory WordItem.fromJson(Map<String, dynamic> json) {
    return WordItem(
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'difficulty': difficulty,
    };
  }
}