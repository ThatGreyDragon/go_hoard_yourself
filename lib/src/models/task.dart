import 'package:go_hoard_yourself/src/models/log.dart';

import '../models/dragon.dart';

abstract class Task {
  String get name;
  String get desc;
  double get timeToComplete;

  double progress = 0.0;

  void onComplete(Dragon dragon);

  void doWork(Dragon dragon, double amount) {
    progress += amount;
    while (progress >= timeToComplete) {
      progress -= timeToComplete;
      onComplete(dragon);
      dragon.log.add(LogEntry("You gathered."));
    }
  }

  double get progressPercent => progress / timeToComplete;
}
