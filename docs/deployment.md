# Розгортання у Production (Deployment)

Оскільки проєкт є клієнтським Flutter-додатком, він компілюється у статику (HTML/CSS/JS) і розгортається на веб-сервері Nginx.

## 1. Вимоги до інфраструктури
- **Сервер:** 1 vCPU, 1 GB RAM, 10 GB SSD.
- **ОС:** Ubuntu 22.04 LTS.
- **ПЗ:** Nginx.

## 2. Збірка та розгортання
1. Зберіть релізну веб-версію:
   `flutter build web --release`
2. Скопіюйте вміст згенерованої папки `build/web/` у директорію веб-сервера `/var/www/html/car_sales`.

## 3. Конфігурація Nginx
Створіть файл `/etc/nginx/sites-available/car_sales`:

server {
    listen 80;
    server_name analytics.example.com;
    root /var/www/html/car_sales;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
}

Активуйте конфігурацію: `sudo ln -s /etc/nginx/sites-available/car_sales /etc/nginx/sites-enabled/` та перезапустіть сервер: `sudo systemctl restart nginx`.

## 4. Перевірка працездатності
Щоб переконатися, що розгортання пройшло успішно:
1. Відкрийте браузер та перейдіть за налаштованою адресою (наприклад, `http://analytics.example.com` або IP-адресою сервера).
2. Якщо інтерфейс додатку завантажився, а в консолі розробника (F12) немає помилок завантаження статичних файлів (HTTP 404), система працює коректно.