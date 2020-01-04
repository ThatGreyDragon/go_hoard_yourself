import 'dart:math';

extension Pick<T> on List<T> {
  T pick([Random rng]) {
    rng = rng ?? Random();
    return this[rng.nextInt(length)];
  }
}
