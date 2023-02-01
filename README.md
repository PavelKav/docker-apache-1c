# docker-apache-1c
## Контейнер докер для публикации базы 1с на разных платформах
##### За основу взят https://github.com/pqr/docker-apache-1c-example/edit/master/README.md, переделан на более новую платформу и организована пакетная установка 1с.
#### Шаг 1 - подготовка рабочего места.
Устанавливаем Docker на локальную машину разработчика (для удобства проверки и отладки) и на целевую Linux машину, где мы собственно и хотим запустить веб-сервер.

Docker работает и на Linux, и на macOS и на Windows. Скорее всего, на машине разработчика (на вашей машине) стоит Windows. Я лично не проверял описанные ниже шаги под Windows, теоретически всё должно сработать, но что-то пойдёт не так, можно не тратить силы и нервы и сделать всё непосредственно на Linux сервере или в локальной виртуальной машине (например, с помощью VirtualBox).

Подробные инструкции по установке Docker: https://docs.docker.com/install/

На сервер будем ставить Docker CE (Community Edition), в частности для Debian инструкция здесь: https://docs.docker.com/install/linux/docker-ce/debian/

При установке на Linux не забудем про этот важный шаг, который описан на отдельной странице в документации: https://docs.docker.com/install/linux/linux-postinstall/

#### Шаг 2 - скачивание дистрибутива 1с.
Создадим директорию для нашего проекта и скачаем в неё дистрибутив 1С Сервер для Linux: https://releases.1c.ru -> Технологическая платформа 8.3 -> Cервер 1С:Предприятия (64-bit) для DEB-based Linux-систем

Скачается файл с расширением .tar.gz - переименуем его в deb64.tar.gz.

#### Шаг 3 - подготовка default.vrd.
Создадим файл с настройками подключения к 1С: default.vrd

Обратите внимание на строку подключения, замените имя сервера 1С (server_name) и имя информационной базы (base_name) на свои.

Если вы ранее уже публиковали свою базу на веб-сервере (не важно на каком: IIS или Apache, Windows или Linux, с помощью конфигуратор или с помощью webinst), у вас точно должен быть .vrd файл, поищите в публичных директориях веб-сервера и используйте его.

#### Шаг 4 - подготовка httpd.conf.

Самое интересное в конце файла.  В строчке LoadModule прописать путь к файлу wsap24.so(изменится платформа 1с)
В 1с Publication поменять путь к базе 1с.

#### Шаг 5 - подготовка Dockerfile.
Создадим файл с именем Dockerfile (без расширения)
Тут ничего менять не надо, единственное можете указать свои директории для сохранения и распаковки дистрибутива 1с.

#### Шаг 6 подготовка docker-compose.yml
Удобнее всего запускать контейнер на сервере с помощью утилиты docker-compose. Но для начала протестируем этот docker-compose опять же на локальной машине.

Устанавливаем docker-compose: https://docs.docker.com/compose/install/

Всё в той же директории проекта (где у нас уже есть Dockerfile, httpd.conf, и др.) создаём файл docker-compose.yml.
Тут так же меняем имя сервера и его IP. Так же меняем порт на любой Ports: 8041(порт на локальной машине):80(порт контейнера), чтобы два апача не стучались в один порт.
И запускаем контейнер с помощью команды:

docker compose up -d --build
