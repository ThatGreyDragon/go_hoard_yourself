import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'log',
  templateUrl: 'log.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class LogComponent extends CommonComponent {
  @Input()
  Dragon dragon;
}
