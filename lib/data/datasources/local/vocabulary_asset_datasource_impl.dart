import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/vocabulary_entity.dart';
import '../../../domain/entities/vocabulary_unit_entity.dart';
import '../../models/vocabulary_model.dart';
import '../../models/vocabulary_unit_model.dart';
import '../interfaces/vocabulary_datasource.dart';

class VocabularyAssetDatasourceImpl implements VocabularyDatasource {
  static const _unitsPath = 'assets/data/japan/units.json';

  List<VocabularyUnitModel>? _unitsCache;

  Future<List<VocabularyUnitModel>> _loadUnits() async {
    if (_unitsCache != null) return _unitsCache!;

    final raw = await rootBundle.loadString(_unitsPath);
    final list = json.decode(raw) as List;
    _unitsCache = list.map((e) => VocabularyUnitModel.fromJson(e as Map<String, dynamic>)).toList();

    return _unitsCache!;
  }

  String _unitAssetPath(String unit) {
    final number = unit.split('_').last;

    return 'assets/data/japan/n5/bai_$number.json';
  }

  Future<List<VocabularyModel>> _loadUnitItems(String unit) async {
    try {
      final raw = await rootBundle.loadString(_unitAssetPath(unit));
      final list = json.decode(raw) as List;

      return list.map((e) => VocabularyModel.fromJson(e as Map<String, dynamic>)).toList();
    } on FlutterError {
      return const [];
    }
  }

  @override
  Future<List<VocabularyUnitEntity>> getUnits(String level) async {
    final units = await _loadUnits();

    return units.where((u) => u.level == level).map((u) => u.toEntity()).toList();
  }

  @override
  Future<List<VocabularyEntity>> getVocabularyByLevel(String level) async {
    final units = (await _loadUnits()).where((u) => u.level == level).toList();
    final result = <VocabularyEntity>[];

    for (final unit in units) {
      final items = await _loadUnitItems(unit.unit);

      for (var index = 0; index < items.length; index++) {
        result.add(
          items[index].toEntity(
            id: '${unit.unit}-$index',
            unit: unit.unit,
            unitName: unit.unitName,
          ),
        );
      }
    }

    return result;
  }
}
