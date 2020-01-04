import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/upgrade.dart';

import '../models/dragon.dart';

import 'package:angular/angular.dart';

@Component(
  selector: 'upgrades',
  templateUrl: 'upgrades.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class UpgradesComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  void research(Upgrade upgrade) {
    dragon.unlockableUpgrades.remove(upgrade);
    dragon.unlockedUpgrades.add(upgrade);
    dragon.sciencePoints -= dragon.upgradeCost(upgrade).floor();
    upgrade.onUnlock(dragon);
  }
}
