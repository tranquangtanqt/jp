import '../../domain/entities/exam_lesson_entity.dart';
import '../../domain/entities/exam_question_entity.dart';

class ExamQuestionModel {
  final Map<String, dynamic> json;

  const ExamQuestionModel(this.json);

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    return const [];
  }

  ExamQuestionEntity toEntity() {
    return ExamQuestionEntity(
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      subtype: json['subtype'] as String?,
      topic: json['topic'] as String?,
      grammarPoint: json['grammar_point'] as String?,
      vocabulary: _stringList(json['vocabulary']),
      kanji: _stringList(json['kanji']),
      jlptSection: json['jlpt_section'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      passage: json['passage'] as String?,
      question: json['question'] as String? ?? '',
      options: _stringList(json['options']),
      answer: (json['answer'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class ExamLessonModel {
  final Map<String, dynamic> json;

  const ExamLessonModel(this.json);

  factory ExamLessonModel.fromJson(Map<String, dynamic> json) => ExamLessonModel(json);

  ExamLessonEntity toEntity() {
    final questions = (json['questions'] as List? ?? [])
        .map((e) => ExamQuestionModel(e as Map<String, dynamic>).toEntity())
        .toList();

    return ExamLessonEntity(
      lesson: (json['lesson'] as num?)?.toInt() ?? 0,
      level: json['level'] as String? ?? '',
      source: json['source'] as String? ?? '',
      questions: questions,
    );
  }
}
