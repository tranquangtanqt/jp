# DATABASE.md - Database Schema Reference

Database: SQLite (`app_database.db`), version: 1 (see `lib/core/services/database/database_config.dart`).

The database only stores **learning progress**. All study content (vocabulary, Kanji, radicals,
exam questions) is bundled as read-only JSON under `assets/data/` and loaded via `rootBundle` —
it is never written to SQLite.

## Tables

### LearningProgress

Per-item progress for the vocabulary and Kanji trainers.

| Column    | Type     | Constraints                              |
| --------- | -------- | ---------------------------------------- |
| feature   | TEXT     | NOT NULL — `vocabulary` \| `kanji` \| `exam` |
| scope     | TEXT     | NOT NULL — level (`N5`) or category (`radicals`, `n5`); for exam: lesson number as string |
| itemId    | TEXT     | NOT NULL — vocab row id (`unit_1-0`), Kanji study id (`k12` / `r34`), or exam question id |
| status    | TEXT     | NOT NULL — `mastered` \| `mistake`       |
| updatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP                |

PRIMARY KEY (`feature`, `scope`, `itemId`, `status`) — a `mastered` and a `mistake` row can
coexist for the same item. Answering an item correctly deletes its `mistake` row; answering
incorrectly inserts one. A correct answer also inserts a `mastered` row.

### ExamProgress

Best score per exam lesson.

| Column    | Type     | Constraints              |
| --------- | -------- | ------------------------ |
| lesson    | INTEGER  | PRIMARY KEY              |
| correct   | INTEGER  | NOT NULL DEFAULT 0       |
| total     | INTEGER  | NOT NULL DEFAULT 0       |
| updatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP |

Updated only when a finished attempt has a higher correct/total ratio than the stored one.

## Access layer

`ProgressLocalDatasourceImpl` (`lib/data/datasources/local/`) wraps all reads/writes;
`ProgressRepositoryImpl` returns `Result<T>`; `progress_usecases.dart` exposes one usecase per
operation. `DatabaseService.initTestDatabase` builds both tables against an in-memory FFI
database for tests.
