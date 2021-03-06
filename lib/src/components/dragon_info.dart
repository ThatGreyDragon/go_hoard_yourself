import 'dart:async';
import 'dart:math';
import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/util.dart';
import '../models/dragon.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'dragon-info',
  templateUrl: 'dragon_info.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class DragonInfoComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  String banner = '';
  Random rng = Random();

  String get stomachFullnessDesc {
    var p = dragon.stomachFullPercent;
    if (p > 1) {
      return 'Overfull!';
    } else if (p > .8) {
      return 'Stuffed';
    } else if (p > .6) {
      return 'Full';
    } else if (p > .4) {
      return 'Saited';
    } else if (p > .2) {
      return 'Hungry';
    } else {
      return 'Starving';
    }
  }

  String get stomachFullnessColor => dragon.stomachFullPercent > 1 ? 'red' : 'black';

  DragonInfoComponent() {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        banner = dragon.unlockedBanners.pick(rng).generate(dragon);
      },
    );
  }
}
