# docker-apache-1c
 Контейнер докер для размещения публикации базы 1с на разных платформах

Шаг 1 - подготовка рабочего места.
Устанавливаем Docker на локальную машину разработчика (для удобства проверки и отладки) и на целевую Linux машину, где мы собственно и хотим запустить веб-сервер.

Docker работает и на Linux, и на macOS и на Windows. Скорее всего, на машине разработчика (на вашей машине) стоит Windows. Я лично не проверял описанные ниже шаги под Windows, теоретически всё должно сработать, но что-то пойдёт не так, можно не тратить силы и нервы и сделать всё непосредственно на Linux сервере или в локальной виртуальной машине (например, с помощью VirtualBox).

Подробные инструкции по установке Docker: https://docs.docker.com/install/

На сервер будем ставить Docker CE (Community Edition), в частности для Ubuntu инструкция здесь: https://docs.docker.com/install/linux/docker-ce/ubuntu/

При установке на Linux не забудем про этот важный шаг, который описан на отдельной странице в документации: https://docs.docker.com/install/linux/linux-postinstall/

Шаг 2 - скачивание дистрибутива 1с.
Создадим директорию для нашего проекта и скачаем в неё дистрибутив 1С Сервер для Linux: https://releases.1c.ru -> Технологическая платформа 8.3 -> Cервер 1С:Предприятия (64-bit) для DEB-based Linux-систем

Скачается файл с расширением .tar.gz - переименуем его в deb64.tar.gz.

Шаг 3 - подготовка default.vrd.
Создадим файл с настройками подключения к 1С: default.vrd

Я привожу пример минимального vrd файла в котором по умолчанию опубликованы все веб-сервисы, все http сервисы и стандартный REST интерфейс (OData).

<?xml version="1.0" encoding="UTF-8"?>
<point xmlns="http://v8.1c.ru/8.2/virtual-resource-system"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		base="/unft"
		ib="Srvr=appbshp0;Ref=unft"
	<ws publishExtensionsByDefault="true" />
	<standardOData enable="false"
	                reuseSession="autouse"
	                sessionMaxAge="20"
	                poolSize="10"
	                poolTimeout="5"/>
	<analytics enable="true"/>
</point>
XML
Обратите внимание на строку подключения, замените имя сервера 1С (appbshp0) и имя информационной базы (unft) на свои.

Если вы ранее уже публиковали свою базу на веб-сервере (не важно на каком: IIS или Apache, Windows или Linux, с помощью конфигуратор или с помощью webinst), у вас точно должен быть .vrd файл, поищите в публичных директориях веб-сервера и используйте его.

Шаг 4 - подготовка httpd.conf.

Самое интересное в конце файла.  В строчке LoadModule прописать путь к файлу wsap24.so(измениться платформа 1с)
В 1с Publication поменять путь к базе 1с.
