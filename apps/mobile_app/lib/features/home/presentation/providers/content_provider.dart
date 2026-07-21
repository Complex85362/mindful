import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class ContentProvider extends ChangeNotifier {
  final GetAuthors _getAuthors;
  final GetQuoteOfTheDay _getQuoteOfTheDay;

  ContentProvider({
    required GetAuthors getAuthors,
    required GetQuoteOfTheDay getQuoteOfTheDay,
  })  : _getAuthors = getAuthors,
        _getQuoteOfTheDay = getQuoteOfTheDay;

  List<Author> _authors = [];
  Quote? _quoteOfTheDay;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false; // same one-shot-per-session guard as MoodProvider

  List<Author> get authors => _authors;
  Quote? get quoteOfTheDay => _quoteOfTheDay;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Look up a single author by id -- used by QuoteOfDayCard to show whose
  /// quote it's displaying, without a second Firestore round trip. Only
  /// works once _authors is already loaded; returns null otherwise.
  Author? authorById(String id) {
    for (final author in _authors) {
      if (author.id == id) return author;
    }
    return null;
  }

  Future<void> loadHomeContent() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    _isLoading = true;
    notifyListeners();

    final authorsResult = await _getAuthors();
    final quoteResult = await _getQuoteOfTheDay();

    authorsResult.fold(
          (failure) => _errorMessage = failure.message,
          (authors) => _authors = authors,
    );
    quoteResult.fold(
          (failure) => _errorMessage ??= failure.message,
          (quote) => _quoteOfTheDay = quote,
    );

    _isLoading = false;
    notifyListeners();
  }
}