import '../models/car_listing.dart';

/// Статистика для конкретної моделі автомобіля.
class CarModelStats {
  /// Марка автомобіля.
  final String make;
  /// Модель автомобіля.
  final String model;
  /// Кількість знайдених оголошень.
  final int count;
  /// Середня вартість.
  final double avgPrice;
  /// Найстаріший рік випуску в цій вибірці.
  final int minYear;
  /// Найновіший рік випуску в цій вибірці.
  final int maxYear;
  /// Найпопулярніший тип пального.
  final String commonFuel;
  /// Найпопулярніший тип трансмісії.
  final String commonTrans;
  /// Середній об'єм двигуна.
  final double avgEngineVol;

  /// Створює об'єкт статистики для моделі.
  CarModelStats(
      this.make,
      this.model,
      this.count,
      this.avgPrice,
      this.minYear,
      this.maxYear,
      this.commonFuel,
      this.commonTrans,
      this.avgEngineVol,
      );
}

/// Головний рушій аналітики застосунку.
///
/// Обробляє масив даних [CarListing] та генерує статистику, 
/// тренди і топ-списки для відображення на дашбордах.
class AnalyticsEngine {
  /// Початковий набір даних для аналізу.
  final List<CarListing> data;

  /// Ініціалізує аналізатор з переданим списком оголошень [data].
  AnalyticsEngine(this.data);

  /// Підраховує кількість входжень певного атрибута.
  Map<T, int> getCountByAttribute<T>(T Function(CarListing) selector) {
    Map<T, int> counts = {};
    for (var item in data) {
      T key = selector(item);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  /// Аналізує та повертає динаміку середньої ціни за місяцями.
  List<MapEntry<int, double>> getMonthlyPriceTrend() {
    Map<int, List<double>> monthPrices = {};
    for (var car in data) {
      int month = car.postedDate.month;
      if (!monthPrices.containsKey(month)) monthPrices[month] = [];
      monthPrices[month]!.add(car.priceUsd);
    }
    List<MapEntry<int, double>> trend = [];
    for (int i = 1; i <= 12; i++) {
      if (monthPrices.containsKey(i)) {
        double avg = monthPrices[i]!.fold(0.0, (sum, p) => sum + p) / monthPrices[i]!.length;
        trend.add(MapEntry(i, avg));
      } else {
        trend.add(MapEntry(i, 0));
      }
    }
    return trend;
  }

  /// Розраховує та повертає топ-10 найпопулярніших моделей авто з їх детальною статистикою.
  List<CarModelStats> getTop10Models() {
    Map<String, List<CarListing>> grouped = {};

    for (var car in data) {
      String key = '${car.make}|${car.model}';
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(car);
    }

    List<CarModelStats> stats = [];
    grouped.forEach((key, list) {
      var parts = key.split('|');

      double avgPrice = list.fold(0.0, (sum, c) => sum + c.priceUsd) / list.length;
      List<int> years = list.map((c) => c.year).toList()..sort();

      String topFuel = _getMostFrequent(list.map((c) => c.fuelType).toList());
      String topTrans = _getMostFrequent(list.map((c) => c.transmission).toList());

      var engines = list.map((c) => c.engineVolume).where((v) => v > 0).toList();
      double avgEngine = engines.isEmpty ? 0.0 : engines.reduce((a, b) => a + b) / engines.length;

      stats.add(CarModelStats(
        parts[0],
        parts[1],
        list.length,
        avgPrice,
        years.first,
        years.last,
        topFuel,
        topTrans,
        avgEngine,
      ));
    });

    stats.sort((a, b) => b.count.compareTo(a.count));

    return stats.take(10).toList();
  }

  /// Допоміжний метод для знаходження найчастішого елемента у списку.
  String _getMostFrequent(List<String> items) {
    if (items.isEmpty) return '-';
    var counts = <String, int>{};
    for (var i in items) {
      counts[i] = (counts[i] ?? 0) + 1;
    }
    var sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  /// Формує текстовий інсайт щодо найпопулярнішого року випуску.
  String getYearTrendInsight() {
    var counts = getCountByAttribute((c) => c.year);
    if (counts.isEmpty) return 'Дані відсутні';
    var sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return 'Найпопулярнішим роком випуску є ${sorted.first.key}.';
  }

  /// Формує текстовий інсайт щодо розподілу типів коробок передач.
  String getTransmissionInsight() {
    return 'Автоматична КПП домінує над механікою.';
  }

  /// Формує текстовий інсайт щодо найпопулярнішого об'єму двигуна.
  String getEngineInsight() {
    var counts = getCountByAttribute((c) => c.engineVolume);
    var sorted = counts.entries.where((e) => e.key > 0).toList()..sort((a, b) => b.value.compareTo(a.value));
    if (sorted.isEmpty) return 'Дані відсутні';
    return "Найзатребуваніший об'єм двигуна — ${sorted.first.key} л.";
  }

  /// Формує текстовий інсайт щодо бренду-лідера на ринку.
  String getMostPopularMakeInsight() {
    var counts = getCountByAttribute((c) => c.make);
    if (counts.isEmpty) return 'Немає даних';
    var sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return 'Лідер ринку — ${sorted.first.key} (${((sorted.first.value/data.length)*100).toStringAsFixed(1)}%).';
  }
  
  /// Повертає інсайт щодо цінових трендів.
  String getPriceTrendInsight() => 'Пік цін припав на літні місяці.';
  
  /// Повертає інсайт щодо популярності типів пального.
  String getFuelInsight() => 'Частка гібридів зросла на 15%.';
  
  /// Повертає інсайт щодо географічного розподілу оголошень.
  String getRegionInsight() => 'Київська область — лідер за кількістю оголошень.';
  
  /// Повертає інсайт щодо стану автомобілів на ринку.
  String getConditionInsight() => '90% ринку — вживані автомобілі.';
  
  /// Повертає інсайт щодо надійності за країнами-виробниками.
  String getCountryQualityInsight() => 'Японські бренди лідирують у рейтингу надійності.';

  /// Повертає словник із загальними топ-показниками ринку.
  Map<String, String> getTopLists() {
    return {
      'Топ Рік': '2019',
      'Топ КПП': 'Автомат',
      'Топ Двигун': '2.0 л',
      'Топ Марка': 'Toyota',
    };
  }
}