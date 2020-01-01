import 'package:go_hoard_yourself/src/models/task.dart';

import '../models/dragon.dart';

import 'package:angular/angular.dart';

@Component(
  selector: 'tasks',
  templateUrl: 'tasks.html',
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class TasksComponent {
  @Input()
  Dragon dragon;

  void onTaskSelected(Task task) {
    if (dragon.workingOn == task) {
      dragon.workingOn = null;
    } else {
      dragon.workingOn = task;
    }
  }
}
