import 'package:equatable/equatable.dart';

class LearningCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool disabled;

  const LearningCategoryEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.disabled = false,
  });

  @override
  List<Object?> get props => [id, name, description, disabled];
}
