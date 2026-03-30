import 'package:flutter_test/flutter_test.dart';
import 'package:car_sales_analytics/utils/analytics_engine.dart';
import 'package:car_sales_analytics/models/car_listing.dart';

void main() {
  group('Жива документація: AnalyticsEngine', () {
    test('Демонстрація роботи з даними та генерації інсайтів', () {
      final sampleCars = [
        CarListing(id: '1', make: 'Toyota', model: 'Camry', priceUsd: 15000, year: 2020, fuelType: 'Бензин', odometerKm: 50000, region: 'Київ', postedDate: DateTime(2024, 1, 15), bodyType: 'Седан', country: 'Японія', condition: 'Вживане', transmission: 'Автомат', engineVolume: 2.5),
        CarListing(id: '2', make: 'Toyota', model: 'Corolla', priceUsd: 10000, year: 2018, fuelType: 'Бензин', odometerKm: 80000, region: 'Львів', postedDate: DateTime(2024, 1, 20), bodyType: 'Седан', country: 'Японія', condition: 'Вживане', transmission: 'Ручна', engineVolume: 1.6),
        CarListing(id: '3', make: 'BMW', model: 'X5', priceUsd: 35000, year: 2021, fuelType: 'Дизель', odometerKm: 30000, region: 'Київ', postedDate: DateTime(2024, 2, 10), bodyType: 'SUV', country: 'Німеччина', condition: 'Вживане', transmission: 'Автомат', engineVolume: 3.0),
      ];

      final engine = AnalyticsEngine(sampleCars);
      
      final topModels = engine.getTop10Models();

      expect(topModels.isNotEmpty, true, reason: 'Метод має повернути список популярних моделей');
      expect(topModels.first.make, 'Toyota', reason: 'Toyota зустрічається найчастіше у нашій вибірці (2 рази)');

      final priceInsight = engine.getPriceTrendInsight();
      expect(priceInsight, isA<String>(), reason: 'Інсайт має бути текстовим рядком');
    });
  });
}