import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/providers/content_provider.dart';
import 'features/home/presentation/providers/favorites_provider.dart';
import 'features/home/presentation/providers/game_provider.dart';
import 'features/home/presentation/providers/mood_provider.dart';
import 'features/home/presentation/providers/streak_provider.dart';
import 'features/home/presentation/screens/main_shell.dart';
import 'features/preferences/presentation/providers/preferences_provider.dart';
import 'features/preferences/presentation/screens/preferences_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MindfulApp());
}

class MindfulApp extends StatelessWidget {
  const MindfulApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRemoteDataSource = AuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);
    final contentRemoteDataSource = ContentRemoteDataSource();
    final contentRepository = ContentRepositoryImpl(contentRemoteDataSource);
    final preferencesRemoteDataSource = PreferencesRemoteDataSource();
    final preferencesRepository = PreferencesRepositoryImpl(preferencesRemoteDataSource);
    final moodRemoteDataSource = MoodRemoteDataSource();
    final moodRepository = MoodRepositoryImpl(moodRemoteDataSource);
    final favoritesRemoteDataSource = FavoritesRemoteDataSource();
    final favoritesRepository = FavoritesRepositoryImpl(favoritesRemoteDataSource);
    final streakRemoteDataSource = StreakRemoteDataSource();
    final streakRepository = StreakRepositoryImpl(streakRemoteDataSource);
    final gameRemoteDataSource = GameRemoteDataSource();
    final gameRepository = GameRepositoryImpl(gameRemoteDataSource);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            signInWithEmail: SignInWithEmail(authRepository),
            signUpWithEmail: SignUpWithEmail(authRepository),
            signOut: SignOut(authRepository),
            authRepository: authRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            getCategories: GetCategories(preferencesRepository),
            savePreferences: SavePreferences(preferencesRepository),
            checkHasPreferences: CheckHasPreferences(preferencesRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MoodProvider(
            logMood: LogMood(moodRepository),
            getLatestMood: GetLatestMood(moodRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ContentProvider(
            getAuthors: GetAuthors(contentRepository),
            getQuoteOfTheDay: GetQuoteOfTheDay(contentRepository),
            getQuoteById: GetQuoteById(contentRepository),
            getBooks: GetBooks(contentRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(
            addFavorite: AddFavorite(favoritesRepository),
            removeFavorite: RemoveFavorite(favoritesRepository),
            getFavorites: GetFavorites(favoritesRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => StreakProvider(
            getStreak: GetStreak(streakRepository),
            recordActivity: RecordActivity(streakRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GameProvider(
            getQuestions: GetQuestions(gameRepository),
            submitAttempt: SubmitAttempt(gameRepository),
            getLeaderboard: GetLeaderboard(gameRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Mindful',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
        home: const AuthGate(),
      ),
    );
  }
}

/// Top-level gate: routes between the unauthenticated flow (Login/Signup)
/// and PreferencesGate, which handles what happens once signed in.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    if (authProvider.isSignedIn) {
      return PreferencesGate(userId: authProvider.currentUser!.uid);
    }
    return const LoginScreen();
  }
}

/// Sits between AuthGate and the real app once a user is signed in. Checks
/// whether they've completed the mandatory preferences step and routes
/// accordingly: PreferencesScreen if not, HomeScreen if so.
class PreferencesGate extends StatefulWidget {
  final String userId;
  const PreferencesGate({super.key, required this.userId});

  @override
  State<PreferencesGate> createState() => _PreferencesGateState();
}

class _PreferencesGateState extends State<PreferencesGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<PreferencesProvider>().checkHasPreferences(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsProvider = context.watch<PreferencesProvider>();


    if (prefsProvider.hasPreferences == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (prefsProvider.hasPreferences == false) {
      return PreferencesScreen(userId: widget.userId);
    }
    return const MainShell();
  }
}