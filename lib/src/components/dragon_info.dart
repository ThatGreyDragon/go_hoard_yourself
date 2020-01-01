import 'package:go_hoard_yourself/src/components/common_component.dart';

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
}
