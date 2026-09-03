import 'package:equatable/equatable.dart';

class ExamQuestionEntity extends Equatable {
  final int id;
  final String type;
  final String? subtype;
  final String? topic;
  final String? grammarPoint;
  final List<String> vocabulary;
  final List<String> kanji;
  final String jlptSection;
  final String frequency;
  final String difficulty;
  final String? passage;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;

  const ExamQuestionEntity({
    required this.id,
    required this.type,
    this.subtype,
    this.topic,
    this.grammarPoint,
    this.vocabulary = const [],
    this.kanji = const [],
    required this.jlptSection,
    required this.frequency,
    required this.difficulty,
    this.passage,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    subtype,
    topic,
    grammarPoint,
    vocabulary,
    kanji,
    jlptSection,
    frequency,
    difficulty,
    passage,
    question,
    options,
    answer,
    explanation,
  ];
}
