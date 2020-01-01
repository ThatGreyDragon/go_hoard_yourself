import 'package:go_hoard_yourself/src/models/log.dart';

import '../models/task.dart';
import '../models/dragon.dart';
import '../data/foods.dart';

class TaskGather extends Task {
  @override
  String get name => 'Gather';

  @override
  String get desc => 'Forage and hunt for something to eat!';

  @override
  double get timeToComplete => 5.0;

  @override
  void onComplete(Dragon dragon) {
    dragon.giveFood(FOOD_BURGER);

    if (dragon.workingOn == this) {
      dragon.log.add(LogEntry('You manage to scrounge up... A cheeseburger? Welp. Time to dig in!'));
    }
  }
}

final TaskGather TASK_GATHER = TaskGather();

final List<Task> TASKS = [
  TASK_GATHER,
];
