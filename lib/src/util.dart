import 'dart:math';

class Weight<T> {
  int weight;
  T value;

  Weight(this.weight, this.value);
}

extension Pick<T> on List<T> {
  T pick([Random rng]) {
    rng = rng ?? Random();
    return this[rng.nextInt(length)];
  }
}

extension PickWeighted<T> on List<Weight<T>> {
  List<T> toUnweighted() {
    var result = <T>[];
    for (var weight in this) {
      for (var i = 0; i < weight.weight; i++) {
        result.add(weight.value);
      }
    }
    return result;
  }

  T pickWeighted([Random rng]) {
    rng = rng ?? Random();
    var unweighted = toUnweighted();
    return unweighted.pick(rng);
  }
}

extension RandomUtils on Random {
  int nextIntBetween(int lower, int upper) {
    if (lower > upper) {
      return nextIntBetween(upper, lower);
    }
    return lower + nextInt(upper - lower + 1);
  }
}
