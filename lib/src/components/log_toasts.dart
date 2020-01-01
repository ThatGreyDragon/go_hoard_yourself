import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:angular/angular.dart';
import 'package:go_hoard_yourself/src/models/log.dart';

@Component(
  selector: 'log-toasts',
  templateUrl: 'log_toasts.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class LogToastsComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  String logColor(LogEntry entry) {
    switch (entry.type) {
      case LogType.INFO:
        return 'alert-secondary';
      case LogType.GOOD:
        return 'alert-success';
      case LogType.BAD:
        return 'alert-danger';
    }
  }
}
