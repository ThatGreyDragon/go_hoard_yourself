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

  TaskGather() {
    maxKoboldsAssignable.flatMods.add(() => 5);
  }
}

class TaskExploreCave extends Task {
  @override
  String get name => 'Explore Cave';

  @override
  String get desc => 'Maybe something good to eat is in there?';

  @override
  double get timeToComplete => 5.0;

  @override
  void onComplete(Dragon dragon) {
    dragon.giveFood(FOOD_KOBOLD);
    dragon.koboldsUnlocked = true;

    if (dragon.workingOn == this) {
      dragon.log.add(LogEntry('You find a kobold! They quickly pledge allegiance to you. Sweet!'));
    }
  }

  TaskExploreCave() {
    maxKoboldsAssignable.flatMods.add(() => 5);
  }
}

final TaskGather TASK_GATHER = TaskGather();
final TaskExploreCave TASK_EXPLORE_CAVE = TaskExploreCave();

final List<Task> TASKS = [
  TASK_GATHER,
  TASK_EXPLORE_CAVE,
];
