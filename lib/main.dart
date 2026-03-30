import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'utils/logger_service.dart';
// import 'screens/login_screen.dart'; // Ваші імпорти
// import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk_UA', null);
  
  // Ініціалізація логера
  AppLogger.init();

  // 75% & 100%: Гарантоване перехоплення помилок UI
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.log.e(
      'Flutter UI Error [ID: ERR-${DateTime.now().millisecondsSinceEpoch}]',
      time: DateTime.now(),
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // 75% & 100%: Перехоплення асинхронних помилок ядра
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.log.f('Critical Core Error', time: DateTime.now(), error: error, stackTrace: stack);
    return true; 
  };

  // 100%: Кастомізована сторінка помилок для кінцевих користувачів
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Ой! Щось пішло не так.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ми вже зафіксували проблему та працюємо над її вирішенням. Спробуйте перезавантажити сторінку.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  AppLogger.log.i('Користувач натиснув "Повідомити про проблему"');
                  // Логіка відправки звіту
                },
                child: const Text('Повідомити про проблему'),
              )
            ],
          ),
        ),
      ),
    );
  };

  runApp(const CarSalesAnalyticsApp());
}

/// Головний віджет додатку
class CarSalesAnalyticsApp extends StatelessWidget {
  /// Конструктор головного віджета
  const CarSalesAnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( // Додано const для покращення продуктивності
      title: 'AutoRia Analytics 2024',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: Text('Головний екран'))), 
    );
  }
}