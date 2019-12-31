abstract class Task {
  String get name;
  double get timeToComplete;

  double progress = 0.0;

  void onComplete();

  void doWork(double amount) {
    progress += amount;
    while (progress >= timeToComplete) {
      progress -= timeToComplete;
      onComplete();
    }
  }
}
