import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../utilities/console_logger.dart';
import 'database_config.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  static DatabaseService get instance => _instance;

  late Database database;

  Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }

    // Get the path to the database
    String path = join(await getDatabasesPath(), DatabaseConfig.dbPath);

    if (kDebugMode) {
      // Only for development purpose
      // await dropDatabase(path);
    }

    // Open database
    database = await openDatabase(
      path,
      version: DatabaseConfig.version,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _upgradeDatabase(db, oldVersion, newVersion);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await Future.wait([
      db.execute(DatabaseConfig.createLearningProgressTable),
      db.execute(DatabaseConfig.createExamProgressTable),
    ]);
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // future migrations
    // if (oldVersion < 2) { ... }
  }

  @visibleForTesting
  Future<void> initTestDatabase({required Database testDatabase}) async {
    database = testDatabase;

    await Future.wait([
      database.execute(DatabaseConfig.createLearningProgressTable),
      database.execute(DatabaseConfig.createExamProgressTable),
    ]);
  }

  Future<void> dropDatabase(String path) async {
    File databaseFile = File(path);

    if (await databaseFile.exists()) {
      await databaseFile.delete();

      cw('Database deleted successfully!');
    } else {
      ce('Database does not exist!');
    }
  }
}
