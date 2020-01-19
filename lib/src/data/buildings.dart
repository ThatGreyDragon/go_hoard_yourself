import 'package:go_hoard_yourself/src/data/tasks.dart';
import 'package:go_hoard_yourself/src/models/building.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

class BuldingHuntingShack extends Building {
  @override
  String get id => 'hunting-shack';

  @override
  String get name => 'Hunting Shack';

  @override
  String get desc => 'With this shack, kobolds can hunt further out, allowing you to have more kobolds hunt at the same time.';

  @override
  double get baseCost => 200;

  @override
  double get factorCost => 1.15;

  BuldingHuntingShack() {
    TASK_GATHER.maxKoboldsAssignable.flatMods.add(() => owned*5.0);
  }
}

class BuildingStomachOil extends Building {
  @override
  double get baseCost => 500;

  @override
  String get desc => 'This bottle of rubbing oils is said to increase your stomach capacity after letting it soak in through your scales. Is it snake oil, or is it the real deal? Only one way to find out!';

  @override
  double get factorCost => 2;

  @override
  String get id => 'stomach-oil';

  @override
  String get name => 'Stomach Oil';

  @override
  void onBought(Dragon dragon) {
    if (owned == 1) {
      dragon.log.add(LogEntry('''You rub the oil onto your scales, and it quickly soaks in, feeling tingly. Wow, you're suddently starving! Your stomach capacity must have been increased...''', LogType.GOOD));
    }

    dragon.stomachCapacity.flatMods.add(() => 10.0);
  }
}

final BuldingHuntingShack BUILDING_HUNTING_SHACK = BuldingHuntingShack();
final BuildingStomachOil BUILDING_STOMACH_OIL = BuildingStomachOil();

final List<Building> BUILDINGS = [
  BUILDING_HUNTING_SHACK,
  BUILDING_STOMACH_OIL,
];
