import 'package:go_hoard_yourself/src/data/tasks.dart';
import 'package:go_hoard_yourself/src/models/building.dart';

class BuldingHuntingShack extends Building {
  @override
  String get id => 'hunting-shack';

  @override
  String get name => 'Hunting Shack';

  @override
  String get desc => 'With this shack, kobolds can hunt further out, allowing you to have more kobolds hunt.';

  @override
  double get baseCost => 100;

  @override
  double get factorCost => 1.05;

  BuldingHuntingShack() {
    TASK_GATHER.maxKoboldsAssignable.flatMods.add(() => owned*5.0);
  }
}

final BuldingHuntingShack BUILDING_HUNTING_SHACK = BuldingHuntingShack();

final List<Building> BUILDINGS = [
  BUILDING_HUNTING_SHACK,
];
