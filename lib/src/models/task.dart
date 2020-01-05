import 'package:go_hoard_yourself/src/data/tasks.dart';
import 'package:go_hoard_yourself/src/models/dragon.dart';
import 'package:go_hoard_yourself/src/models/stat.dart';

abstract class Task {
  String get id;
  String get name;
  String get desc;
  double get timeToComplete;

  double progress = 0.0;
  int koboldsAssigned = 0;
  Stat maxKoboldsAssignable = Stat(0.0);
  int timesCompleted = 0;

  void onComplete(Dragon dragon);

  void doWork(Dragon dragon, double amount) {
    progress += amount;
    while (progress >= timeToComplete) {
      progress -= timeToComplete;
      timesCompleted++;
      onComplete(dragon);
    }
  }

  double get progressPercent => progress / timeToComplete;

  dynamic toJSON() => {
    'id': id,
    'progress': progress,
    'kobolds': koboldsAssigned,
    'timesCompleted': timesCompleted,
  };

  Task();
  factory Task.fromJSON(dynamic json) {
    var task = Task.fromID(json['id']);
    task.progress = json['progress'] ?? 0.0;
    task.koboldsAssigned = json['kobolds'] ?? 0;
    task.timesCompleted = json['timesCompleted'] ?? 0;
    return task;
  }
  factory Task.fromID(String id) => TASKS.firstWhere((t) => t.id == id, orElse: () => null);

  void reset() {
    progress = 0.0;
    koboldsAssigned = 0;
    timesCompleted = 0;
  }
}
