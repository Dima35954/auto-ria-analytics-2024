#!/bin/bash
echo "==> Початок збірки Flutter Web..."
flutter build web --release
echo "==> Архівування білду для відправки на сервер..."
tar -czvf release_build.tar.gz -C build/web .
echo "==> Готово. Архів release_build.tar.gz можна деплоїти."