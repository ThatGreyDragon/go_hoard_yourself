import 'package:go_hoard_yourself/src/models/upgrade.dart';

class UpgradeFeeding extends Upgrade {
  @override
  String get name => 'Mealtimes';

  @override
  String get desc => 'Teach your kobolds the three most important times of day... Breakfast, lunch, and dinner. With this knowledge, you can train them to give you food at regular intervals.';

  @override
  int get cost => 100;
}

final UpgradeFeeding UPGRADE_FEEDING = UpgradeFeeding();

final List<Upgrade> UPGRADES = [
  UPGRADE_FEEDING,
];
