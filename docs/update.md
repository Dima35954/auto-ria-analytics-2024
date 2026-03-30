# Оновлення системи (Update & Rollback)

## 1. Підготовка до оновлення
1. Зробіть збірку нової версії коду: `flutter build web --release`.
2. Виконайте процедуру створення резервної копії (див. `backup.md`).

## 2. Процес оновлення
Час простою (downtime) складає менше 1 хвилини.
1. Очистіть поточну директорію на сервері: `rm -rf /var/www/html/car_sales/*`
2. Скопіюйте нові файли зі збірки `build/web/` у `/var/www/html/car_sales/`.
3. Очистіть кеш Nginx (опціонально): `sudo systemctl reload nginx`.

## 3. Процедура відкату (Rollback)
У разі виявлення критичних помилок після оновлення:
1. Видаліть проблемні файли: `rm -rf /var/www/html/car_sales/*`
2. Розпакуйте останній стабільний бекап:
   `tar -xzf /backups/car_sales_backup_YYYY-MM-DD.tar.gz -C /var/www/html/car_sales/`