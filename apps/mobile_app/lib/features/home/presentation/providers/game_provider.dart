import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

enum QuizPhase { idle, playing, finished }

class GameProvider extends ChangeNotifier {
  final GetQuestions _getQuestions;
  final SubmitAttempt _submitAttempt;
  final GetLeaderboard _getLeaderboard;

  GameProvider({
    required GetQuestions getQuestions,
    required SubmitAttempt submitAttempt,
    required GetLeaderboard getLeaderboard,
  })  : _getQuestions = getQuestions,
        _submitAttempt = submitAttempt,
        _getLeaderboard = getLeaderboard;

  List<GameQuestion> _questions = [];
  List<LeaderboardEntry> _leaderboard = [];
  QuizPhase _phase = QuizPhase.idle;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex; // null = not yet answered current question
  bool _isLoading = false;
  String? _errorMessage;

  List<GameQuestion> get questions => _questions;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  QuizPhase get phase => _phase;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  GameQuestion? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  Future<void> loadLeaderboard() async {
    final result = await _getLeaderboard();
    result.fold(
          (failure) => _errorMessage = failure.message,
          (entries) => _leaderboard = entries,
    );
    notifyListeners();
  }

  Future<void> startQuiz() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getQuestions();
    result.fold(
          (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
          (questions) {
        if (questions.isEmpty) {
          _errorMessage = 'No quiz questions available yet.';
          _isLoading = false;
          notifyListeners();
          return;
        }
        questions.shuffle(); // different order each playthrough
        _questions = questions;
        _currentIndex = 0;
        _score = 0;
        _selectedAnswerIndex = null;
        _phase = QuizPhase.playing;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void answerQuestion(int selectedIndex) {
    if (_selectedAnswerIndex != null) return; // already locked in for this question
    _selectedAnswerIndex = selectedIndex;
    if (selectedIndex == currentQuestion?.correctAnswerIndex) {
      _score += 10;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      notifyListeners();
    } else {
      _phase = QuizPhase.finished;
      notifyListeners();
    }
  }

  Future<void> submitScore({required String userId, required String displayName}) async {
    final result = await _submitAttempt(userId: userId, displayName: displayName, score: _score);
    result.fold((failure) => _errorMessage = failure.message, (_) {});
    await loadLeaderboard(); // refresh so the new score shows immediately
  }

  void resetQuiz() {
    _phase = QuizPhase.idle;
    _currentIndex = 0;
    _score = 0;
    _selectedAnswerIndex = null;
    notifyListeners();
  }
}