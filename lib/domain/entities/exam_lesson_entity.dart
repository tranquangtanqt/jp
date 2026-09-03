import 'package:equatable/equatable.dart';

import 'exam_question_entity.dart';

class ExamLessonEntity extends Equatable {
  final int lesson;
  final String level;
  final String source;
  final List<ExamQuestionEntity> questions;

  const ExamLessonEntity({
    required this.lesson,
    required this.level,
    required this.source,
    required this.questions,
  });

  @override
  List<Object?> get props => [lesson, level, source, questions];
}
