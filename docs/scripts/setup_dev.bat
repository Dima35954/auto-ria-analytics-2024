@echo off
chcp 65001 > nul
echo [INFO] Завантаження залежностей проекту...
call flutter pub get
echo [SUCCESS] Середовище розробки готове!
pause