import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Вхідна точка
import 'theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart'; // Додати в pubspec intl

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uk_UA', null); // Для українських дат
  runApp(const CarSalesAnalyticsApp());
}

class CarSalesAnalyticsApp extends StatelessWidget {
  const CarSalesAnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoRia Analytics 2024',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(), // Після логіну перейдемо на HomeMenuScreen
    );
  }
}