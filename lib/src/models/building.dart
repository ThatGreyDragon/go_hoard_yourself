import 'dart:math';

abstract class Building {
  String get name;
  String get desc;
  double get baseCost;
  double get factorCost;

  int owned = 0;

  double get cost => baseCost * pow(factorCost, owned);
}
