import '../../domain/entities/learning_category_entity.dart';

class LearningCategoryModel {
  final String id;
  final String name;
  final String description;
  final bool disabled;

  const LearningCategoryModel({
    required this.id,
    required this.name,
    this.description = '',
    this.disabled = false,
  });

  factory LearningCategoryModel.fromJson(Map<String, dynamic> json) {
    return LearningCategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      disabled: json['disabled'] as bool? ?? false,
    );
  }

  LearningCategoryEntity toEntity() => LearningCategoryEntity(
    id: id,
    name: name,
    description: description,
    disabled: disabled,
  );
}
