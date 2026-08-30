import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/database/database_service.dart';
import '../../core/services/tts/tts_service.dart';
import '../../data/datasources/interfaces/exam_datasource.dart';
import '../../data/datasources/interfaces/kanji_datasource.dart';
import '../../data/datasources/interfaces/progress_datasource.dart';
import '../../data/datasources/interfaces/vocabulary_datasource.dart';
import '../../data/datasources/local/exam_asset_datasource_impl.dart';
import '../../data/datasources/local/kanji_asset_datasource_impl.dart';
import '../../data/datasources/local/progress_local_datasource_impl.dart';
import '../../data/datasources/local/vocabulary_asset_datasource_impl.dart';
import '../../data/repositories/exam_repository_impl.dart';
import '../../data/repositories/kanji_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';
import '../../domain/repositories/exam_repository.dart';
import '../../domain/repositories/kanji_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../routes/app_routes.dart';

// Startup overrides
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden at app startup.'),
);

// Routes
final appRoutesProvider = Provider<AppRoutes>((ref) => AppRoutes());

// Services
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService.instance);
final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

// Datasources
final vocabularyDatasourceProvider = Provider<VocabularyDatasource>((ref) => VocabularyAssetDatasourceImpl());
final kanjiDatasourceProvider = Provider<KanjiDatasource>((ref) => KanjiAssetDatasourceImpl());
final examDatasourceProvider = Provider<ExamDatasource>((ref) => ExamAssetDatasourceImpl());
final progressDatasourceProvider = Provider<ProgressDatasource>(
  (ref) => ProgressLocalDatasourceImpl(ref.watch(databaseServiceProvider)),
);

// Repositories
final vocabularyRepositoryProvider = Provider<VocabularyRepository>(
  (ref) => VocabularyRepositoryImpl(ref.watch(vocabularyDatasourceProvider)),
);
final kanjiRepositoryProvider = Provider<KanjiRepository>(
  (ref) => KanjiRepositoryImpl(ref.watch(kanjiDatasourceProvider)),
);
final examRepositoryProvider = Provider<ExamRepository>(
  (ref) => ExamRepositoryImpl(ref.watch(examDatasourceProvider)),
);
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepositoryImpl(ref.watch(progressDatasourceProvider)),
);
