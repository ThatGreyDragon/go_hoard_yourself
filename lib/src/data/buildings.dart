import 'package:go_hoard_yourself/src/data/tasks.dart';
import 'package:go_hoard_yourself/src/data/upgrades.dart';
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

class BuildingOldBook extends Building {
  @override
  double get baseCost => 10000;

  @override
  String get desc => '''Looks like they're selling dusty old books here at the market. If you bought one, you could probably learn some things from it... If you put in the eoffrt of pouring over it.''';

  @override
  double get factorCost => 1.2;

  @override
  String get id => 'old-book';

  @override
  String get name => 'Old Book';

  BuildingOldBook() {
    TASK_STUDY_BOOKS.maxKoboldsAssignable.flatMods.add(() => owned*1.0);
  }

  @override
  void onBought(Dragon dragon) {
    if (owned == 1) {
      dragon.log.add(LogEntry('''You bought an old book! Now it's time to figure out what this book is about... It's a bit dense, so it'll take some work.''', LogType.GOOD));
      dragon.unlockedTasks.add(TASK_STUDY_BOOKS);
      dragon.unlockableUpgrades.add(UPGRADE_FEEDING);
      dragon.unlockableUpgrades.add(UPGRADE_TRADING);
    }
  }
}

final BuldingHuntingShack BUILDING_HUNTING_SHACK = BuldingHuntingShack();
final BuildingStomachOil BUILDING_STOMACH_OIL = BuildingStomachOil();
final BuildingOldBook BUILDING_OLD_BOOK = BuildingOldBook();

final List<Building> BUILDINGS = [
  BUILDING_HUNTING_SHACK,
  BUILDING_STOMACH_OIL,
  BUILDING_OLD_BOOK,
];
