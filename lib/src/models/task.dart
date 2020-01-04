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

  void onComplete(Dragon dragon);

  void doWork(Dragon dragon, double amount) {
    progress += amount;
    while (progress >= timeToComplete) {
      progress -= timeToComplete;
      onComplete(dragon);
    }
  }

  double get progressPercent => progress / timeToComplete;

  dynamic toJSON() => {
    'id': id,
    'progress': progress,
    'kobolds': koboldsAssigned,
  };

  Task();
  factory Task.fromJSON(dynamic json) {
    var task = Task.fromID(json['id']);
    task.progress = json['progress'];
    task.koboldsAssigned = json['kobolds'];
    return task;
  }
  factory Task.fromID(String id) => TASKS.firstWhere((t) => t.id == id, orElse: () => null);
}
