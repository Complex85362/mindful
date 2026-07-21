import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class MoodProvider extends ChangeNotifier {
  final LogMood _logMood;
  final GetLatestMood _getLatestMood;

  MoodProvider({
    required LogMood logMood,
    required GetLatestMood getLatestMood,
  })  : _logMood = logMood,
        _getLatestMood = getLatestMood;

  MoodLog? _latestMood;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasCheckedLatest = false; // guards against re-fetching on every rebuild

  MoodLog? get latestMood => _latestMood;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// True only if the most recent mood entry was logged today. This is
  /// computed here, client-side, rather than queried from Firestore --
  /// see the datasource comment for why the query itself just fetches
  /// "most recent" and leaves the date comparison to us.
  bool get hasCheckedInToday {
    final mood = _latestMood;
    if (mood == null) return false;
    final now = DateTime.now();
    return mood.loggedAt.year == now.year &&
        mood.loggedAt.month == now.month &&
        mood.loggedAt.day == now.day;
  }

  Future<void> checkLatestMood(String userId) async {
    if (_hasCheckedLatest) return; // only ever fetch once per app session
    _hasCheckedLatest = true;

    final result = await _getLatestMood(userId: userId);
    result.fold(
          (failure) {
        // Fail quiet here -- if we can't tell whether they checked in
        // today, defaulting to "show the prompt" is the safer UX than
        // blocking the whole Home tab on an error banner.
      },
          (mood) {
        _latestMood = mood;
        notifyListeners();
      },
    );
  }

  Future<bool> logMood({required String userId, required String mood}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _logMood(userId: userId, mood: mood);
    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
          (loggedMood) {
        _latestMood = loggedMood;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
}