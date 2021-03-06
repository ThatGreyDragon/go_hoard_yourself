import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

@Component(
  selector: 'log',
  templateUrl: 'log.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class LogComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  String logColor(LogEntry entry) {
    switch (entry.type) {
      case LogType.INFO:
        return 'black';
      case LogType.GOOD:
        return 'green';
      case LogType.BAD:
        return 'red';
    }
  }
}
