import 'package:go_hoard_yourself/src/models/dragon.dart';

abstract class Upgrade {
  String get name;
  String get desc;
  int get cost;
  
  void onUnlock(Dragon dragon) {}
}
