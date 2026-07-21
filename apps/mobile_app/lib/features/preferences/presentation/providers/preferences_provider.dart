import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Manages preferences state for the mobile app's UI, mirroring the pattern
/// established by AuthProvider: a ChangeNotifier that wraps use cases, and
/// is the ONLY thing in this feature's presentation layer that touches core.
class PreferencesProvider extends ChangeNotifier {
  final GetCategories _getCategories;
  final SavePreferences _savePreferences;
  final CheckHasPreferences _checkHasPreferences;

  PreferencesProvider({
    required GetCategories getCategories,
    required SavePreferences savePreferences,
    required CheckHasPreferences checkHasPreferences,
  })  : _getCategories = getCategories,
        _savePreferences = savePreferences,
        _checkHasPreferences = checkHasPreferences;

  List<WellnessCategory> _categories = [];
  final Set<String> _selectedCategoryIds = {};
  bool _isLoading = false;
  String? _errorMessage;

  // null = not yet checked, true/false = known state. AuthGate/PreferencesGate
  // shows a spinner while this is null, so we never flash the wrong screen.
  bool? _hasPreferences;

  List<WellnessCategory> get categories => _categories;
  Set<String> get selectedCategoryIds => _selectedCategoryIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get hasPreferences => _hasPreferences;

  Future<void> checkHasPreferences(String userId) async {
    final result = await _checkHasPreferences(userId: userId);
    result.fold(
          (failure) {
        // If the check itself fails (e.g. offline), default to showing the
        // preferences screen rather than trapping the user on a spinner
        // forever with no way forward.
        _hasPreferences = false;
        notifyListeners();
      },
          (has) {
        _hasPreferences = has;
        notifyListeners();
      },
    );
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getCategories();
    result.fold(
          (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
          (categories) {
        _categories = categories;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void toggleCategory(String categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    notifyListeners();
  }

  Future<bool> savePreferences(String userId) async {
    if (_selectedCategoryIds.isEmpty) {
      _errorMessage = 'Pick at least one category to continue.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _savePreferences(
      userId: userId,
      categoryIds: _selectedCategoryIds.toList(),
    );
    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
          (_) {
        _isLoading = false;
        _hasPreferences = true; // flips PreferencesGate straight to HomeScreen
        notifyListeners();
        return true;
      },
    );
  }
}