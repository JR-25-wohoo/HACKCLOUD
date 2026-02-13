import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../providers/game_provider.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String category;
  final String categoryName;

  const GameScreen({
    super.key,
    required this.category,
    required this.categoryName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastFlipTime;

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWords();
    });
  }

  Future<void> _loadWords() async {
    try {
      await Provider.of<GameProvider>(context, listen: false)
          .loadCategory(widget.category);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading words: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _startAccelerometer() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        final now = DateTime.now();
        if (_lastFlipTime != null &&
            now.difference(_lastFlipTime!).inMilliseconds < 1000) {
          return;
        }
        if (event.z < -8.0) {
          _lastFlipTime = now;
          _onCorrectGuess();
        }
      },
    );
  }

  void _onCorrectGuess() {
    HapticFeedback.mediumImpact();
    Provider.of<GameProvider>(context, listen: false).nextWord();
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'Loading ${widget.categoryName}...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        if (!gameProvider.hasWords) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No words found in this category',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.categoryName),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Text(
                      '✓ ${gameProvider.correctCount}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(gameProvider.currentDifficulty)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getDifficultyColor(
                          gameProvider.currentDifficulty,
                        ),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      gameProvider.currentDifficulty.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(
                          gameProvider.currentDifficulty,
                        ),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Semantics(
                        label: 'Current word: ${gameProvider.currentWord}',
                        child: Text(
                          gameProvider.currentWord,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_downward,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Flip DOWN when guessed',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    correctCount: gameProvider.correctCount,
                    skippedCount: gameProvider.skippedCount,
                    categoryName: widget.categoryName,
                  ),
                ),
              );
            },
            backgroundColor: colorScheme.error,
            icon: const Icon(Icons.stop),
            label: const Text('End Game'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
