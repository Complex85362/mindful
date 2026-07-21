import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class StreakProvider extends ChangeNotifier {
  final GetStreak _getStreak;
  final RecordActivity _recordActivity;

  StreakProvider({
    required GetStreak getStreak,
    required RecordActivity recordActivity,
  })  : _getStreak = getStreak,
        _recordActivity = recordActivity;

  Streak? _streak;
  bool _hasLoaded = false;

  int get currentStreak => _streak?.currentStreak ?? 0;

  Future<void> loadStreak(String userId) async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    final result = await _getStreak(userId);
    result.fold(
          (failure) {}, // fail quiet -- streak badge just shows 0, not critical
          (streak) {
        _streak = streak;
        notifyListeners();
      },
    );
  }

  /// Called after a meaningful daily action (currently: logging a mood).
  /// Safe to call multiple times in a day -- the datasource's transaction
  /// already no-ops if today's activity is already recorded.
  Future<void> recordActivity(String userId) async {
    final result = await _recordActivity(userId);
    result.fold(
          (failure) {},
          (streak) {
        _streak = streak;
        notifyListeners();
      },
    );
  }
}