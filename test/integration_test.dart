import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:car_sales_analytics/models/car_listing.dart';
import 'package:car_sales_analytics/utils/analytics_engine.dart';
import 'integration_test.mocks.dart';

class DataRepository {
  List<CarListing> fetchAllCars() => [];
}

@GenerateMocks([DataRepository])
void main() {
  group('Integration Tests: AnalyticsEngine <-> DataRepository', () {
    late MockDataRepository mockRepository;
    late AnalyticsEngine analyticsEngine;

    setUp(() {
      mockRepository = MockDataRepository();
    });

    test('INT-01: Engine correctly processes data fetching from Repository', () {
      final integrationData = [
        CarListing(
            id: '101', make: 'Audi', model: 'A4', year: 2022, priceUsd: 30000,
            fuelType: 'Diesel', odometerKm: 1000, region: 'Kyiv',
            postedDate: DateTime(2024, 5, 10), bodyType: 'Sedan', country: 'Germany',
            condition: 'Used', transmission: 'Auto', engineVolume: 2.0
        ),
        CarListing(
            id: '102', make: 'Audi', model: 'A4', year: 2022, priceUsd: 40000,
            fuelType: 'Diesel', odometerKm: 2000, region: 'Kyiv',
            postedDate: DateTime(2024, 5, 15), bodyType: 'Sedan', country: 'Germany',
            condition: 'Used', transmission: 'Auto', engineVolume: 2.0
        ),
      ];

      when(mockRepository.fetchAllCars()).thenReturn(integrationData);

      analyticsEngine = AnalyticsEngine(mockRepository.fetchAllCars());
      final trend = analyticsEngine.getMonthlyPriceTrend();

      verify(mockRepository.fetchAllCars()).called(1);

      final mayData = trend.firstWhere((e) => e.key == 5);
      expect(mayData.value, 35000.0);
    });

    test('INT-02: System handles empty data stream gracefully', () {
      when(mockRepository.fetchAllCars()).thenReturn([]);

      analyticsEngine = AnalyticsEngine(mockRepository.fetchAllCars());
      final topList = analyticsEngine.getTop10Models();

      verify(mockRepository.fetchAllCars()).called(1);
      expect(topList, isEmpty);
    });
  });
}