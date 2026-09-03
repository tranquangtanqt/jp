class DatabaseConfig {
  // Prevents instantiation and extension
  DatabaseConfig._();

  static const String dbPath = 'app_database.db';
  static const int version = 1;

  static const String learningProgressTableName = 'LearningProgress';
  static const String examProgressTableName = 'ExamProgress';

  static const String createLearningProgressTable =
      '''
CREATE TABLE IF NOT EXISTS '$learningProgressTableName' (
    'feature' TEXT NOT NULL,
    'scope' TEXT NOT NULL,
    'itemId' TEXT NOT NULL,
    'status' TEXT NOT NULL,
    'updatedAt' DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ('feature', 'scope', 'itemId', 'status')
);
''';

  static const String createExamProgressTable =
      '''
CREATE TABLE IF NOT EXISTS '$examProgressTableName' (
    'lesson' INTEGER PRIMARY KEY,
    'correct' INTEGER NOT NULL DEFAULT 0,
    'total' INTEGER NOT NULL DEFAULT 0,
    'updatedAt' DATETIME DEFAULT CURRENT_TIMESTAMP
);
''';
}
