bool isAlternativeValue(String value, Map<int, String> map) {
  var result = false;
  for (var entity in map.values) {
    if (value.toUpperCase().contains(entity)) {
      result = true;
    }
  }

  return result;
}

int parseAlternativeValue(String value, Map<int, String> map) {
  var num = int.tryParse(value);
  if (num != null) {
    return num;
  }
  var result = value.toUpperCase();
  var entities = map.keys.toList()..sort((a, b) => b.compareTo(a));
  for (var key in entities) {
    result = result.replaceAll(map[key]!, key.toString());
  }

  return int.parse(result);
}

String convertAlternativeValue(
  bool isAlternative,
  int value,
  Map<int, String> valueMap,
) {
  if (!isAlternative) {
    return value.toString();
  }

  return valueMap[value].toString();
}

Map<int, String> rangeListToMap(
  List<int> list, {
  String Function(int num)? converter,
}) {
  var converterMethod = converter ?? (int num) => num.toString();
  Map<int, String> map = {};
  for (var num in list) {
    map.addAll({num: converterMethod(num)});
  }

  return map;
}

List<int> generateRangeList(int a, [int? stop, int? step]) {
  int start;

  if (stop == null) {
    start = 0;
    stop = a;
  } else {
    start = a;
  }

  if (step == 0) throw Exception('Step cannot be 0');

  if (step == null) {
    start < stop
        ? step = 1 // walk forwards
        : step = -1;
  } // walk backwards

  // return [] if step is in wrong direction
  return start < stop == step > 0
      ? List<int>.generate(
          ((start - stop) / step).abs().ceil(),
          (int i) => start + (i * step!),
        )
      : [];
}

String serialNumberName(int number) {
  if (number == 1) {
    return '1st';
  } else if (number == 2) {
    return '2nd';
  } else if (number == 3) {
    return '3rd';
  }

  return '${number}th';
}

Map<int, String> getMapFromIndex(List<String> entities, int startIndex) {
  final Map<int, String> results = {};

  var index = startIndex;
  for (var entity in entities) {
    results.addAll({
      index: entity,
    });
    index++;
  }

  return results;
}
