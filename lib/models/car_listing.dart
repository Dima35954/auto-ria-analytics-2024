/// Модель даних, що представляє одне оголошення про продаж автомобіля.
///
/// Зберігає всю ключову інформацію про транспортний засіб, включаючи 
/// його характеристики, ціну та інформацію про публікацію.
class CarListing {
  /// Унікальний ідентифікатор оголошення.
  final String id;
  
  /// Марка автомобіля (наприклад, Toyota, BMW).
  final String make;
  
  /// Модель автомобіля (наприклад, Camry, X5).
  final String model;
  
  /// Рік випуску автомобіля.
  final int year;
  
  /// Вартість автомобіля у доларах США.
  final double priceUsd;
  
  /// Тип пального (наприклад, Бензин, Дизель, Електро).
  final String fuelType;
  
  /// Пробіг автомобіля у кілометрах.
  final int odometerKm;
  
  /// Область або регіон, де продається автомобіль.
  final String region;
  
  /// Дата та час публікації оголошення.
  final DateTime postedDate;
  
  /// Тип кузова (наприклад, Седан, Кросовер).
  final String bodyType;
  
  /// Країна походження або реєстрації автомобіля.
  final String country;
  
  /// Стан автомобіля (наприклад, Не битий, Потребує ремонту).
  final String condition;

  /// Тип коробки передач (наприклад, Автомат, Ручна).
  final String transmission;
  
  /// Об'єм двигуна у літрах.
  final double engineVolume;

  /// Створює новий екземпляр оголошення про продаж авто.
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