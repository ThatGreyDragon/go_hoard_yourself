import '../models/task.dart';

class TaskGather extends Task {
  @override
  String get name => 'Gather';

  @override
  double get timeToComplete => 10.0;

  @override
  void onComplete() {
    
  }
}

List<Task> tasks = [
  TaskGather(),
];
