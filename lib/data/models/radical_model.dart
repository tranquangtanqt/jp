import '../../domain/entities/radical_entity.dart';

class RadicalModel {
  final int id;
  final int number;
  final String char;
  final int strokes;
  final String hanViet;
  final String meaning;
  final bool standalone;
  final bool common;

  const RadicalModel({
    required this.id,
    required this.number,
    required this.char,
    required this.strokes,
    required this.hanViet,
    required this.meaning,
    this.standalone = true,
    this.common = false,
  });

  factory RadicalModel.fromJson(Map<String, dynamic> json) {
    return RadicalModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      number: (json['number'] as num?)?.toInt() ?? 0,
      char: json['char'] as String? ?? '',
      strokes: (json['strokes'] as num?)?.toInt() ?? 0,
      hanViet: json['hanViet'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      standalone: json['standalone'] as bool? ?? true,
      common: json['common'] as bool? ?? false,
    );
  }

  RadicalEntity toEntity() => RadicalEntity(
    id: id,
    number: number,
    char: char,
    strokes: strokes,
    hanViet: hanViet,
    meaning: meaning,
    standalone: standalone,
    common: common,
  );
}
