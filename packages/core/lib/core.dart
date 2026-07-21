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