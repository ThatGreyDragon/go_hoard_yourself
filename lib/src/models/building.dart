import 'dart:math';

import 'package:go_hoard_yourself/src/models/dragon.dart';

abstract class Building {
  String get name;
  String get desc;
  double get baseCost;
  double get factorCost;

  int owned = 0;

  double get cost => baseCost * pow(factorCost, owned);

  void onBought(Dragon dragon) {}
}
