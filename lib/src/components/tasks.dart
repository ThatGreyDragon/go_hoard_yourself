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

  bool canDecreaseAllocation(Task task) {
    return task.koboldsAssigned > 0;
  }

  void decreaseAllocation(Task task) {
    if (canDecreaseAllocation(task)) {
      task.koboldsAssigned--;
    }
  }

  bool canIncreaseAllocation(Task task) {
    // this is not "koboldsAssigned < maxKoboldsAssignable" because maxKoboldsAssignable may be non-integral
    return dragon.koboldsInUse < dragon.kobolds && task.koboldsAssigned+1 <= task.maxKoboldsAssignable.value;
  }

  void increaseAllocation(Task task) {
    if (canIncreaseAllocation(task)) {
      task.koboldsAssigned++;
    }
  }
}
