import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correctCount;
  final int skippedCount;
  final String categoryName;

  const ResultScreen({
    super.key,
    required this.correctCount,
    this.skippedCount = 0,
    required this.categoryName,
  });

  String _getPerformanceMessage() {
    if (correctCount >= 30) return 'Outstanding! 🔥';
    if (correctCount >= 20) return 'Excellent! 🌟';
    if (correctCount >= 10) return 'Great Job! 👏';
    if (correctCount >= 5) return 'Good Effort! 👍';
    return 'Keep Practicing! 💪';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceVariant = colorScheme.surface.withValues(alpha: 0.6);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _getPerformanceMessage(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$correctCount',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Words Guessed Correctly',
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (skippedCount > 0) ...[
                      const SizedBox(height: 20),
                      Divider(
                        color: colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.skip_next,
                            color: Colors.orange,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$skippedCount',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Words Skipped',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Category: $categoryName',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Play Again'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Back to Categories'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
