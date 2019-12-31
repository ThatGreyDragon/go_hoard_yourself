import 'src/components/dragon_info.dart';
import 'src/models/dragon.dart';

import 'package:angular/angular.dart';

@Component(
  selector: 'go-hoard-yourself',
  styleUrls: ['go_hoard_yourself.css'],
  templateUrl: 'go_hoard_yourself.html',
  directives: [coreDirectives, DragonInfoComponent],
)
class GoHoardYourself {
  Dragon dragon = Dragon('Testerino');
}
