import 'dart:math';

import 'package:go_hoard_yourself/src/data/buildings.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';

abstract class Building {
  String get id;
  String get name;
  String get desc;
  double get baseCost;
  double get factorCost;

  int owned = 0;

  double get cost => baseCost * pow(factorCost, owned);

  void onBought(Dragon dragon) {}
  void onLoad(Dragon dragon) {}

  dynamic toJSON() => {
    'id': id,
    'owned': owned,
  };

  Building();
  factory Building.fromJSON(dynamic json) {
    var building = Building.fromID(json['id']);
    building.owned = json['owned'];
    return building;
  }
  factory Building.fromID(String id) => BUILDINGS.firstWhere((b) => b.id == id, orElse: () => null);
}
