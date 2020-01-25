import 'package:go_hoard_yourself/src/data/upgrades.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';

abstract class Upgrade {
  String get id;
  String get name;
  String get desc;
  int get cost;
  
  void onUnlock(Dragon dragon) {}
  void onLoad(Dragon dragon) {}

  Upgrade();
  factory Upgrade.fromID(String id) => UPGRADES.firstWhere((u) => u.id == id, orElse: () => null);
}
