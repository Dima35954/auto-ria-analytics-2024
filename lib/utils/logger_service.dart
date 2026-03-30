import 'package:logger/logger.dart';

/// Глобальний сервіс логування
class AppLogger {
  // 65%: Рівень логування задається без перекомпіляції через --dart-define=LOG_LEVEL=debug
  static const String _envLogLevel = String.fromEnvironment('LOG_LEVEL', defaultValue: 'info');
  
  /// Інстанс логера
  static late Logger log;
  
  /// Унікальний ідентифікатор сесії
  static final String sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  /// Ініціалізація логера
  static void init() {
    Level level = _getLevel(_envLogLevel);
    
    log = Logger(
      level: level,
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 100,
        colors: true,
        printEmojis: true,
        // Виправлено застарілий параметр printTime:
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, 
      ),
    );
    // Виправлено подвійні лапки на одинарні
    log.i('Систему логування ініціалізовано. Рівень: ${level.name}. Сесія: $sessionId');
  }

  static Level _getLevel(String levelStr) {
    switch (levelStr.toLowerCase()) {
      case 'debug': return Level.debug;
      case 'warning': return Level.warning;
      case 'error': return Level.error;
      case 'fatal': return Level.fatal;
      case 'info': 
      default: return Level.info;
    }
  }
}

/// 75%: Базова стратегія обробки помилок з унікальними ID та контекстом
class AppException implements Exception {
  /// Повідомлення про помилку
  final String message;
  
  /// Унікальний ідентифікатор помилки
  final String errorId;
  
  /// Додатковий контекст стану системи
  final Map<String, dynamic>? context;

  /// Створення нового винятку з унікальним ID
  AppException(this.message, {this.context}) 
      : errorId = 'ERR-${DateTime.now().millisecondsSinceEpoch}';

  @override
  String toString() => 'AppException[$errorId]: $message. Context: $context';
}