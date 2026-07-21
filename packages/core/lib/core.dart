// Common
export 'src/common/failure.dart';
export 'src/common/result.dart';

// Auth feature — domain
export 'src/features/auth/domain/entities/user.dart';
export 'src/features/auth/domain/repositories/auth_repository.dart';
export 'src/features/auth/domain/usecases/sign_in_with_email.dart';
export 'src/features/auth/domain/usecases/sign_up_with_email.dart';
export 'src/features/auth/domain/usecases/sign_in_with_google.dart';
export 'src/features/auth/domain/usecases/sign_out.dart';

// Auth feature — data
export 'src/features/auth/data/datasources/auth_remote_datasource.dart';
export 'src/features/auth/data/repositories/auth_repository_impl.dart';

export 'src/features/preferences/domain/entities/wellness_category.dart';
export 'src/features/preferences/domain/repositories/preferences_repository.dart';
export 'src/features/preferences/domain/usecases/get_categories.dart';
export 'src/features/preferences/domain/usecases/save_preferences.dart';
export 'src/features/preferences/domain/usecases/check_has_preferences.dart';

// Preferences feature — data
export 'src/features/preferences/data/datasources/preferences_remote_datasource.dart';
export 'src/features/preferences/data/repositories/preferences_repository_impl.dart';



// Content feature — domain
export 'src/features/content/domain/entities/author.dart';
export 'src/features/content/domain/entities/quote.dart';
export 'src/features/content/domain/repositories/content_repository.dart';
export 'src/features/content/domain/usecases/get_authors.dart';
export 'src/features/content/domain/usecases/get_quote_of_the_day.dart';

// Content feature — data
export 'src/features/content/data/datasources/content_remote_datasource.dart';
export 'src/features/content/data/repositories/content_repository_impl.dart';

// Mood feature — domain
export 'src/features/mood/domain/entities/mood_log.dart';
export 'src/features/mood/domain/repositories/mood_repository.dart';
export 'src/features/mood/domain/usecases/log_mood.dart';
export 'src/features/mood/domain/usecases/get_latest_mood.dart';

// Mood feature — data
export 'src/features/mood/data/datasources/mood_remote_datasource.dart';
export 'src/features/mood/data/repositories/mood_repository_impl.dart';

// Content feature — additional usecase
export 'src/features/content/domain/usecases/get_quote_by_id.dart';

// Favorites feature — domain
export 'src/features/favorites/domain/entities/favorite.dart';
export 'src/features/favorites/domain/repositories/favorites_repository.dart';
export 'src/features/favorites/domain/usecases/add_favorite.dart';
export 'src/features/favorites/domain/usecases/remove_favorite.dart';
export 'src/features/favorites/domain/usecases/get_favorites.dart';

// Favorites feature — data
export 'src/features/favorites/data/datasources/favorites_remote_datasource.dart';
export 'src/features/favorites/data/repositories/favorites_repository_impl.dart';
// Content feature — books
export 'src/features/content/domain/entities/book.dart';
export 'src/features/content/domain/usecases/get_books.dart';