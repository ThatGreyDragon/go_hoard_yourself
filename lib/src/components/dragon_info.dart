import '../models/dragon.dart';

import 'package:angular/angular.dart';

@Component(
  selector: 'dragon-info',
  templateUrl: 'dragon_info.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class DragonInfoComponent {
  @Input()
  Dragon dragon;
}
