import 'package:go_hoard_yourself/src/components/common_component.dart';
import 'package:go_hoard_yourself/src/models/task.dart';

import '../models/dragon.dart';

import 'package:angular/angular.dart';

@Component(
  selector: 'tasks',
  templateUrl: 'tasks.html',
  directives: [coreDirectives, InitDirective],
  pipes: [commonPipes],
)
class TasksComponent extends CommonComponent {
  @Input()
  Dragon dragon;

  void onTaskSelected(Task task) {
    if (dragon.workingOn == task) {
      dragon.workingOn = null;
    } else {
      dragon.workingOn = task;
    }
  }

  void decreaseAllocation(Task task) {
    if (task.koboldsAssigned > 0) {
      task.koboldsAssigned--;
    }
  }

  void increaseAllocation(Task task) {
    if (dragon.koboldsInUse < dragon.kobolds) {
      task.koboldsAssigned++;
    }
  }
}
