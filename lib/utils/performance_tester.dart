import 'package:intl/intl.dart';
import '../models/car_listing.dart';
import 'logger_service.dart';

/// Клас для профілювання та тестування продуктивності (ЛР 8)
class PerformanceTester {
  static List<CarListing> _mockData = [];

  /// 1. Створення тестового набору даних (50 000 записів)
  static void generateDataset() {
    AppLogger.log.i('Генерація 50 000 тестових записів для профілювання...');
    _mockData = List.generate(50000, (index) {
      return CarListing(
        id: index.toString(),
        make: index % 2 == 0 ? 'Toyota' : (index % 3 == 0 ? 'BMW' : 'Audi'),
        model: 'Model $index',
        year: 2000 + (index % 24),
        priceUsd: 10000.0 + (index % 5000),
        fuelType: index % 2 == 0 ? 'Gasoline' : 'Diesel',
        odometerKm: 50000 + (index * 10),
        region: 'Київ',
        postedDate: DateTime.now().subtract(Duration(days: index % 30)),
        bodyType: 'Sedan',
        country: 'Україна', // Додано
        condition: 'Не битий', // Додано
        transmission: 'Автомат', // Додано
        engineVolume: 2.0 + (index % 3), // Додано
      );
    });
  }

  /// 2. Запуск усіх тестів і порівняння
  static void runBenchmark() {
    if (_mockData.isEmpty) generateDataset();
    AppLogger.log.i('--- ПОЧАТОК ПРОФІЛЮВАННЯ ---');

    _testTopBrands();
    _testAveragePrice();
    _testFiltering();

    AppLogger.log.i('--- КІНЕЦЬ ПРОФІЛЮВАННЯ ---');
  }

  // === ГАРЯЧА ТОЧКА 1: Підрахунок марок (O(N^2) vs O(N)) ===
  static void _testTopBrands() {
    final swSlow = Stopwatch()..start();
    List<String> uniqueBrands = _mockData.map((c) => c.make).toSet().toList();
    Map<String, int> slowResult = {};
    for (var brand in uniqueBrands) {
      slowResult[brand] = _mockData.where((c) => c.make == brand).length;
    }
    swSlow.stop();

    final swFast = Stopwatch()..start();
    Map<String, int> fastResult = {};
    for (var car in _mockData) {
      fastResult[car.make] = (fastResult[car.make] ?? 0) + 1;
    }
    swFast.stop();

    AppLogger.log.w('TEST 1 (Top Brands): Повільно: ${swSlow.elapsedMilliseconds} мс | Швидко: ${swFast.elapsedMilliseconds} мс');
  }

  // === ГАРЯЧА ТОЧКА 2: Розрахунок середньої ціни ===
  static void _testAveragePrice() {
    final swSlow = Stopwatch()..start();
    double slowSum = 0;
    for (var car in _mockData) {
      var formatter = NumberFormat.currency(symbol: '\$'); 
      formatter.format(car.priceUsd); // Використовуємо об'єкт formatter
      slowSum += car.priceUsd;
    }
    swSlow.stop();

    final swFast = Stopwatch()..start();
    double fastSum = 0;
    var formatter = NumberFormat.currency(symbol: '\$');
    for (var car in _mockData) {
      formatter.format(car.priceUsd); // Використовуємо об'єкт formatter
      fastSum += car.priceUsd;
    }
    swFast.stop();

    // Тепер ми виводимо slowSum та fastSum, тому вони вважаються використаними
    AppLogger.log.w('TEST 2 (Avg Price): Повільно: ${swSlow.elapsedMilliseconds} мс (Сума: $slowSum) | Швидко: ${swFast.elapsedMilliseconds} мс (Сума: $fastSum)');
  }

  // === ГАРЯЧА ТОЧКА 3: Фільтрація ===
  static void _testFiltering() {
    final swSlow = Stopwatch()..start();
    var slowList = _mockData
        .where((c) => c.year > 2010).toList()
        .where((c) => c.priceUsd < 12000).toList()
        .map((c) => c.make).toList();
    swSlow.stop();

    final swFast = Stopwatch()..start();
    var fastList = _mockData
        .where((c) => c.year > 2010 && c.priceUsd < 12000)
        .map((c) => c.make)
        .toList();
    swFast.stop();

    // Виводимо довжину списків, щоб довести, що фільтрація працює однаково
    AppLogger.log.w('TEST 3 (Filtering): Повільно: ${swSlow.elapsedMilliseconds} мс (Елементів: ${slowList.length}) | Швидко: ${swFast.elapsedMilliseconds} мс (Елементів: ${fastList.length})');
  }
}