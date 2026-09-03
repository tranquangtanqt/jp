import 'package:equatable/equatable.dart';

enum ProgressStatus { mastered, mistake }

enum ProgressFeature { vocabulary, kanji, exam }

/// Aggregated progress for one scope (level / kanji category).
class LearningProgressEntity extends Equatable {
  final Set<String> masteredIds;
  final Set<String> mistakeIds;

  const LearningProgressEntity({
    this.masteredIds = const {},
    this.mistakeIds = const {},
  });

  @override
  List<Object?> get props => [masteredIds, mistakeIds];
}

class ExamProgressEntity extends Equatable {
  final int lesson;
  final int correct;
  final int total;

  const ExamProgressEntity({
    required this.lesson,
    this.correct = 0,
    this.total = 0,
  });

  @override
  List<Object?> get props => [lesson, correct, total];
}
