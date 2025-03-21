abstract class LogSink {
  Future<void> init();
  void logEvent(String eventType, Map<String, dynamic> data);
}
