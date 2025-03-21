import 'package:flexi_logger/src/log_sink.dart';

class DefaultLogSink implements LogSink {
  @override
  Future<void> init() async {
    // Başlatılacak bir şey yok
  }

  @override
  void logEvent(String eventType, Map<String, dynamic> data) {
    // Olay türüne göre renk ve emoji belirleme
    String emoji;
    // String colorCode;
    switch (eventType) {
      case 'page_view':
        emoji = '👀'; // Gözler emoji’si
      // colorCode = '\x1B[34m'; // Mavi
      case 'page_close':
        emoji = '👋'; // Sayfa kapandı - Elveda
      // colorCode = '\x1B[90m'; // Gri
      case 'button_click':
        emoji = '👆'; // Tıklama emoji’si
      // colorCode = '\x1B[32m'; // Yeşil
      case 'dialog_shown':
        emoji = '🔔'; // Bildirim emoji’si
      // colorCode = '\x1B[33m'; // Sarı
      case 'error':
        emoji = '🔥'; // ya da ❗, 💥, 🛑 gibi bir şey
      // colorCode = '\x1B[31m'; // Kırmızı
      default:
        emoji = 'ℹ️'; // Bilgi emoji’si
      // colorCode = '\x1B[37m'; // Beyaz
    }

    // Log metnini oluşturma
    final logMessage = '$emoji [$eventType] $data';

    print(logMessage);
  }
}
