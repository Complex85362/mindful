import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
/// Manages authentication state for the mobile app's UI.
///
/// This is a ChangeNotifier -- Flutter's built-in "observable" pattern.
/// Screens that wrap themselves in a Consumer<AuthProvider> (or watch it via
/// context.watch) automatically rebuild whenever notifyListeners() is
/// called here. This class is the ONLY thing in the presentation layer that
/// touches the use cases from core -- screens never call use cases directly.
class AuthProvider extends ChangeNotifier{
  final SignInWithEmail _signInWIthEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final AuthRepository _authRepository;

  StreamSubscription<User?>? _authStateSubscription;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required AuthRepository authRepository,
  }) : _signInWIthEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _authRepository = authRepository{
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }


  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _currentUser !=null;

  Future<bool> signIn({required String email, required String password}) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _signInWIthEmail(email: email, password: password);

    return result.fold(
          (failure){
        _errorMessage=failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
          (user){
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> signUp({required String email, required String password,required String displayName,}) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result= await _signUpWithEmail(email:email, password: password, displayName: displayName);

    return result.fold(
          (failure){
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
          (user){
        _currentUser=user;
        _isLoading=false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> signOut() async{
    await _signOut();
  }
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _signInWithGoogle();

    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
          (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  @override
  void dispose(){
    _authStateSubscription?.cancel();
    super.dispose();
  }
}