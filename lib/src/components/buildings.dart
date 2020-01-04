import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/building.dart';

import '../models/dragon.dart';

import 'package:angular/angular.dart';

@Component(
  selector: 'buildings',
  templateUrl: 'buildings.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class BuildingsComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  void build(Building building) {
    if (!dragon.affordable(building)) return;
    dragon.gold -= dragon.buildingCost(building).floor();
    building.owned++;
  }
}
