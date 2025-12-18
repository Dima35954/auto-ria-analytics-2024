class CarListing {
  final String id;
  final String make;
  final String model;
  final int year;
  final double priceUsd;
  final String fuelType;
  final int odometerKm;
  final String region;
  final DateTime postedDate;
  final String bodyType;
  final String country;
  final String condition;

  final String transmission;
  final double engineVolume;

  CarListing({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.priceUsd,
    required this.fuelType,
    required this.odometerKm,
    required this.region,
    required this.postedDate,
    required this.bodyType,
    required this.country,
    required this.condition,
    required this.transmission,
    required this.engineVolume,
  });
}