enum LogType {
  INFO,
  GOOD,
  BAD,
}

class LogEntry {
  String message;
  LogType type;
  DateTime time;

  LogEntry(this.message, [this.type = LogType.INFO]) {
    time = DateTime.now();
  }
}
