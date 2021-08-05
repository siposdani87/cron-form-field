range(int a, [int? stop, int? step]) {
  int start;

  if (stop == null) {
    start = 0;
    stop = a;
  } else {
    start = a;
  }

  if (step == 0) throw Exception('Step cannot be 0');

  if (step == null)
    start < stop
        ? step = 1 // walk forwards
        : step = -1; // walk backwards

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
