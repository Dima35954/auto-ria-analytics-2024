import 'dart:math';
import '../models/car_listing.dart';

class MockData {
  static final Random _random = Random();

  static const List<String> makes = ['Toyota', 'BMW', 'Audi', 'Volkswagen', 'Mercedes-Benz', 'Renault', 'Skoda', 'Ford', 'Nissan', 'Hyundai', 'KIA', 'Mazda'];
  static const List<String> fuels = ['Бензин', 'Дизель', 'Електро', 'Гібрид', 'Газ/Бензин'];
  static const List<String> regions = ['Київська', 'Львівська', 'Одеська', 'Дніпропетровська', 'Харківська'];
  static const List<String> bodyTypes = ['Седан', 'SUV', 'Хетчбек', 'Універсал', 'Купе'];
  static const List<String> countries = ['Німеччина', 'Японія', 'США', 'Франція', 'Корея', 'Чехія'];
  static const List<String> conditions = ['Вживане', 'Нове', 'Після ДТП'];

  static const List<String> transmissions = ['Автомат', 'Ручна', 'Робот', 'Варіатор', 'Тіптронік'];
  static const List<double> engineVolumes = [1.2, 1.4, 1.5, 1.6, 1.8, 2.0, 2.2, 2.4, 2.5, 3.0, 3.5, 4.0, 0.0];

  static List<CarListing> getCarListings() {
    return List.generate(1000, (index) {
      String make = makes[_random.nextInt(makes.length)];
      String fuel = fuels[_random.nextInt(fuels.length)];

      String country = 'Інша';
      if (['BMW', 'Audi', 'Volkswagen', 'Mercedes-Benz'].contains(make)) country = 'Німеччина';
      else if (['Toyota', 'Nissan', 'Mazda'].contains(make)) country = 'Японія';
      else if (['Ford'].contains(make)) country = 'США';
      else if (['Renault'].contains(make)) country = 'Франція';
      else if (['Hyundai', 'KIA'].contains(make)) country = 'Корея';
      else if (['Skoda'].contains(make)) country = 'Чехія';

      double engVol = fuel == 'Електро' ? 0.0 : engineVolumes[_random.nextInt(engineVolumes.length - 1)];

      return CarListing(
        id: 'ad_${index + 1000}',
        make: make,
        model: 'Model ${_random.nextInt(5) + 1}',
        year: 2010 + _random.nextInt(15),
        priceUsd: _generatePrice(make),
        fuelType: fuel,
        odometerKm: _random.nextInt(250000),
        region: regions[_random.nextInt(regions.length)],
        postedDate: DateTime(2024, _random.nextInt(12) + 1, _random.nextInt(28) + 1),
        bodyType: bodyTypes[_random.nextInt(bodyTypes.length)],
        country: country,
        condition: conditions[_random.nextDouble() > 0.9 ? 1 : 0],
        transmission: transmissions[_random.nextInt(transmissions.length)],
        engineVolume: engVol,
      );
    });
  }

  static double _generatePrice(String make) {
    double base = 8000;
    if (make == 'BMW' || make == 'Mercedes-Benz') base = 25000;
    return base + _random.nextInt(40000).toDouble();
  }
}