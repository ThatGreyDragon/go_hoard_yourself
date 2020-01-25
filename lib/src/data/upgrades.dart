import 'package:go_hoard_yourself/src/models/upgrade.dart';

class UpgradeFeeding extends Upgrade {
  @override
  String get id => 'feeding';

  @override
  String get name => 'Meals for Beginners';

  @override
  String get desc => '''Teach your kobolds the three most important times of day... Breakfast, lunch, and dinner. With this knowledge, you can train them to give you food at regular intervals! How convienient!''';

  @override
  int get cost => 1;
}

class UpgradeTrading extends Upgrade {
  @override
  int get cost => 10;

  @override
  String get desc => '''Get your very own stall set up at the market! Kobolds make great buisnesspeople, right? Either way, with this research, you can sell excess food you have for gold.''';

  @override
  String get id => 'trading';

  @override
  String get name => 'Entrepeneurship 101';
}

final UpgradeFeeding UPGRADE_FEEDING = UpgradeFeeding();
final UpgradeTrading UPGRADE_TRADING = UpgradeTrading();

final List<Upgrade> UPGRADES = [
  UPGRADE_FEEDING,
  UPGRADE_TRADING,
];
