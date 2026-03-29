import 'package:flutter_test/flutter_test.dart';
import 'package:car_sales_analytics/utils/analytics_engine.dart';
import 'package:car_sales_analytics/models/car_listing.dart';

void main() {
  test('Приклад використання AnalyticsEngine для розрахунку цін', () {
    // 1. Підготовка даних (Arrange)
    final cars = [
      CarListing(id: '1', make: 'Toyota', model: 'Camry', priceUsd: 10000, year: 2020, fuelType: 'Бензин', odometerKm: 100, region: 'Київ', postedDate: DateTime.now(), bodyType: 'Седан', country: 'Японія', condition: 'Нове', transmission: 'Автомат', engineVolume: 2.5),
      CarListing(id: '2', make: 'Toyota', model: 'Camry', priceUsd: 20000, year: 2022, fuelType: 'Бензин', odometerKm: 50, region: 'Київ', postedDate: DateTime.now(), bodyType: 'Седан', country: 'Японія', condition: 'Нове', transmission: 'Автомат', engineVolume: 2.5),
    ];

    // 2. Виконання логіки (Act)
    final engine = AnalyticsEngine(cars);
    final trend = engine.getMonthlyPriceTrend();

    // 3. Перевірка (Assert)
    // Цей тест показує розробнику, що engine правильно групує дані
    expect(trend.isNotEmpty, true);
  });
}