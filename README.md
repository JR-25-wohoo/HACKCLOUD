# 🎭 BollyAct

Bollywood & India themed charades. Act it out, flip your phone to score.

I wanted a simple party game that felt desi and didn’t need the internet—so I made this. One person holds the phone on their forehead, everyone else acts out the word on screen. When you guess right, flip the phone down. That’s it.

---

## What it does

Classic dumb charades, on your phone. You pick a category (Bollywood movies, songs, places in India, international places). Words show one at a time. Your friends act; you guess. Flip the phone **down** when you get it right to move to the next word. No buttons, just tilt. At the end you get a little score and a “play again” so the next round can start.

**Quick ref:** Flip down = correct. (Flip up for skip is in the code but not wired in the UI yet.)

---

## Why I built it

I like party games and I like building things. This was a chance to mix traditional charades with Indian/Bollywood themes and a bit of tilt-to-interact. The goal was something small, fun, and offline—clear structure, no bloat. If it makes one game night a bit more fun, that’s enough.

---

## How to play

1. Open the app, pick a category.
2. Hold the phone on your forehead (screen facing away).
3. Friends act out the word.
4. When you guess correctly, flip the phone down.
5. Tap **End Game** when you’re done. See your score, then play again or go back to categories.

Use a **real device**—tilt uses the accelerometer, so emulators might not behave right.

---

## Run it yourself

You’ll need [Flutter](https://flutter.dev/docs/get-started/install) installed.

```bash
git clone https://github.com/your-username/charades.git
cd charades
flutter pub get
flutter run
```

---

## Architecture

Clean and simple: one place for UI, one for state, one for loading data. Here’s how it’s laid out.

**Folder structure**

```
lib/
├── main.dart                 # App entry, theme, portrait lock
├── app_constants.dart        # App name & shared constants
├── screens/
│   ├── splash_screen.dart    # Short delay, then → home
│   ├── home_screen.dart      # Category list (cards)
│   ├── game_screen.dart      # Word display + accelerometer
│   └── result_screen.dart   # Score + play again / back
├── providers/
│   └── game_provider.dart    # Game state (words, index, counts)
├── services/
│   └── word_loader.dart      # Load & shuffle category JSON
├── models/
│   └── word_item.dart       # title + difficulty
└── widgets/                  # Reusable bits (if any)

assets/
└── data/                     # bollywood_movies.json, etc.
```

**How it fits together**

- **GameProvider** (Provider) — Holds the current word list, index, correct/skip counts. Loads a category via `WordLoader`, shuffles it, and exposes `nextWord()` / `skipWord()` / `reset()`. Screens listen with `Consumer<GameProvider>` or `Provider.of`.
- **WordLoader** — Reads `assets/data/<category>.json`, parses into `WordItem` list. Called by the provider when you pick a category.
- **Game screen** — Subscribes to `accelerometerEventStream()`; when z < -8 (phone flipped down), it calls `gameProvider.nextWord()`. No game logic in the UI, just “user did this → tell the provider.”
- **Flow** — Splash → Home → Game (with category) → Result → back to Home. Navigation is push/pushReplacement and `popUntil(isFirst)` for “back to categories.”

If you’re poking around, start from `lib/main.dart` and follow the routes; the structure is pretty straightforward.

---

## Maybe later

Timer per round, scores/leaderboard, background music, multiplayer, nicer animations. We’ll see.

---

Made with ❤️ by Tech-No-Phile.
