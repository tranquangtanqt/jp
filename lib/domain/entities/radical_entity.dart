import 'package:equatable/equatable.dart';

class RadicalEntity extends Equatable {
  final int id;
  final int number;
  final String char;
  final int strokes;
  final String hanViet;
  final String meaning;
  final bool standalone;
  final bool common;

  const RadicalEntity({
    required this.id,
    required this.number,
    required this.char,
    required this.strokes,
    required this.hanViet,
    required this.meaning,
    this.standalone = true,
    this.common = false,
  });

  @override
  List<Object?> get props => [id, number, char, strokes, hanViet, meaning, standalone, common];
}
