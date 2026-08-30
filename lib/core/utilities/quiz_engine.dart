import 'dart:math';

final _random = Random();

/// Returns a new shuffled copy of [list].
List<T> shuffled<T>(Iterable<T> list) {
  final result = List<T>.of(list);

  for (var i = result.length - 1; i > 0; i--) {
    final j = _random.nextInt(i + 1);
    final tmp = result[i];
    result[i] = result[j];
    result[j] = tmp;
  }

  return result;
}

/// Picks up to [count] distractor items from [pool], excluding [exclude].
List<T> pickDistractors<T>(List<T> pool, bool Function(T) exclude, int count) {
  return shuffled(pool.where((e) => !exclude(e))).take(count).toList();
}
