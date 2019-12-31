import '../models/task.dart';
import '../models/dragon.dart';
import '../data/foods.dart';

class TaskGather extends Task {
  @override
  String get name => 'Gather';

  @override
  double get timeToComplete => 10.0;

  @override
  void onComplete(Dragon dragon) {
    dragon.giveFood(FOOD_BURGER);
  }
}

final TaskGather TASK_GATHER = TaskGather();

final List<Task> TASKS = [
  TASK_GATHER,
];
