import 'package:flutter_test/flutter_test.dart';
import 'package:car_sales_analytics/models/car_listing.dart';
import 'package:car_sales_analytics/utils/analytics_engine.dart';

void main() {
  final testData = [
    CarListing(
      id: '1', make: 'Toyota', model: 'Camry', year: 2020, priceUsd: 20000,
      fuelType: 'Бензин', odometerKm: 50000, region: 'Kyiv',
      postedDate: DateTime(2024, 1, 15), bodyType: 'Sedan', country: 'Japan',
      condition: 'Used', transmission: 'Автомат', engineVolume: 2.5,
    ),
    CarListing(
      id: '2', make: 'Toyota', model: 'Corolla', year: 2021, priceUsd: 10000,
      fuelType: 'Дизель', odometerKm: 30000, region: 'Lviv',
      postedDate: DateTime(2024, 1, 20), bodyType: 'Sedan', country: 'Japan',
      condition: 'Used', transmission: 'Ручна', engineVolume: 1.6,
    ),
    CarListing(
      id: '3', make: 'BMW', model: 'X5', year: 2022, priceUsd: 60000,
      fuelType: 'Бензин', odometerKm: 10000, region: 'Kyiv',
      postedDate: DateTime(2024, 2, 10), bodyType: 'SUV', country: 'Germany',
      condition: 'Used', transmission: 'Автомат', engineVolume: 3.0,
    ),
  ];

  group('AnalyticsEngine Unit Tests', () {
    late AnalyticsEngine engine;

    setUp(() {
      engine = AnalyticsEngine(testData);
    });

    test('getMonthlyPriceTrend calculates correct averages', () {
      final trend = engine.getMonthlyPriceTrend();

      final jan = trend.firstWhere((e) => e.key == 1);
      expect(jan.value, 15000.0);

      final feb = trend.firstWhere((e) => e.key == 2);
      expect(feb.value, 60000.0);

      final mar = trend.firstWhere((e) => e.key == 3);
      expect(mar.value, 0.0);
    });

    test('getTop10Models sorts by sales count', () {
      final extraData = [...testData, testData[0]];
      final newEngine = AnalyticsEngine(extraData);

      final top = newEngine.getTop10Models();

      expect(top.first.model, 'Camry');
      expect(top.first.count, 2);
    });

    test('getTransmissionInsight identifies dominant type', () {
      final text = engine.getTransmissionInsight();
      expect(text, contains('Автоматична КПП домінує'));
    });
  });
}